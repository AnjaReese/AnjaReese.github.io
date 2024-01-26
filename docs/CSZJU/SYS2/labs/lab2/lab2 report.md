## 1 实验步骤

### 1.1 在 lab1 的基础上实现 Forwarding 机制

- 建议在 lab1 的基础上实现 forward 通过测试，再进行第 2 步
添加了 Forwarding 的数据通路：

![[img/PipelineWithForwarding.png]]

另外，修改了 RegFile，使得使用上升沿的同时能解决同时读寄存器读写冲突。

```verilog
`timescale 1ns / 1ps

module Regs(
  input         clk,
  input         rst,
  input         we, 
  input  [4:0]  read_addr_1,
  input  [4:0]  read_addr_2,
  input  [4:0]  write_addr,
  input  [63:0] write_data,
  output [63:0] read_data_1,
  output [63:0] read_data_2
);

  integer i;
  reg [63:0] register [1:31]; // x1 - x31, x0 keeps zero

  assign read_data_1 = (we & write_addr == read_addr_1 & write_addr != 0) ? write_data : (read_addr_1 ? register[read_addr_1] : 0); // read
  assign read_data_2 = (we & write_addr == read_addr_2 & write_addr != 0) ? write_data : (read_addr_2 ? register[read_addr_2] : 0); // read

  always @(posedge clk  or posedge rst) begin
      if (rst == 1) for (i = 1; i <= 31; i = i + 1) register[i] <= 0; // reset
      else if (we == 1 && write_addr != 0) register[write_addr] <= write_data ; // write register
  end

endmodule
```

### 1.2 根据 3.2 的方法将 AXI4-lite 框架补充完整

#### 1.2.1 将 PipelineCPU 封装成 Core 和 RAM

#### 1.2.2 编写 FSM， Core 的接口和 RaceController

在 Core 中的修改主要是把提前一拍传入 Bram 的信号（主要是 pc 和 mem 阶段 ）移回对应的阶段以及重写 RaceController，并且在做地址的接出时不做截断，传完整地址。

| 起始状态 | 目标状态 | 条件 | 任务 |
| :---: | :---: | :---: | :---: |
| IDLE  | DATA  | wen_cpu \| ren_cpu (MEM请求) | mem_stall 信号和 if_stall 信号 |
| IDLE  | INST  | MEM阶段未发送请求， IF 阶段发送请求  | 发送 IF 请求信息给 CoreAxi_lite ，开启 if_stall 信号  |
| DATA  | DATA  | CoreAxi_lite 未返回 valid 信号      |  等待，保持 mem_stall 和 if_stall 信号   |
| DATA  | IDLE  | CoreAxi_lite 返回 valid 信号        |  关闭 mem_stall 信号，关闭给 CoreAxi_lite 的请求 |
| DATA  | INST  | 不会发生                         |  不会发生                     |
| INST  | INST  | CoreAxi_lite 未返回 valid 信号      |  等待，保持 if_stall 信号        |
| INST  | IDLE  | CoreAxi_lite 返回 valid 信号        |  关闭 if_stall 信号，关闭给 CoreAxi_lite 的请求 |
| INST  | DATA  | 不会发生                         |  不会发生                     |

由于不存在 MEM 阶段和 IF 阶段都没有发起请求的情况，我在实际设置状态机时没有使用到 `if_request` 信号，在 core 中默认该信号一直开启。

```verilog
assign mem_request = wen_cpu | ren_cpu
always @(posedge clk or negedge rnst) begin
	if (~rstn) begin
		state <= IDLE;
		keep_if_stall = 1;
	end
	else if (state == IDLE) begin
		if (mem_request) begin
			state <= DATA;
			keep_if_stall = 1;
		end
		else begin // 由于不存在两种请求都没有的情况，直接else了
			state <= INST;
			keep_if_stall = 1;
		end
	end
	else if (state == INST) begin
		if (valid_mem) begin
			state <= IDLE;
			keep_if_stall = 0;
		end
		else bigin
			state <= INST;
			keep_if_stall = 1;
		end
	end
	else if (state == DATA) begin
		if (valid_mem) begin
			state <= IDLE;
		end
		else begin
			state <= DATA;
			keep_if_stall = 1;
		end
	end
end

assign rdata_cpu = rdata_mem;
assign inst = pc[2] ? rdata_mem[63:32] : rdata_mem[31:0];
assign wmask_mem = wmask_cpu;
assign wdata_mem = wdata_cpu;
assign address_mem = state == INST ? pc : address_cpu;

assign if_stall = keep_if_stall;
assign mem_stall = mem_requets & ~valid_mem;
assign ren_mem = (state == DATA & ren_cpu) | (state == INST);
assign wen_mem =  state == DATA & wen_cpu;
```

RaceControl 的传入信号中，`jump` 信号接入 `decode_exe[19] & branch_flag_exe`，即确认跳转信号。

```verilog
module racecontrol_Axi(
    input        jump,
    input  [4:0] rs1_exe,
    input  [4:0] rs2_exe,
    input  [4:0] rd_mem,
    input        re_mem_mem,
    input        we_mem_mem,
    input        we_mem_exe,
    input        if_stall,
    input        mem_stall,

    output       stall_PC,
    output       stall_IFID,
    output       stall_IDEXE,
    output       stall_EXEMEM,
    output       stall_MEMWB,
    output       flush_IFID,
    output       flush_IDEXE,
    output       flush_EXEMEM,
    output       flush_MEMWB
);

wire data_race_if = ((rs1_exe == rd_mem)|(rs2_exe == rd_mem)) & (re_mem_mem | we_mem_mem);     // MEM 为 Load
wire predict_flush = jump;

assign stall_PC = mem_stall | if_stall;
assign stall_IFID = mem_stall | data_race_if;
assign flush_IFID =  ~stall_IFID & (if_stall | predict_flush);

assign stall_IDEXE = predict_flush & if_stall | mem_stall | data_race_if;
assign flush_IDEXE = ~stall_IDEXE & predict_flush;

assign stall_EXEMEM = mem_stall;
assign flush_EXEMEM = ~stall_EXEMEM & (data_race_if | predict_flush & if_stall);

assign stall_MEMWB = 1'b0;
assign flush_MEMWB = mem_stall;

endmodule
```

### 1.3 进行仿真测试，以检验 CPU 基本功能

![[lab2simpassed.png]]

### 1.4 进行上板测试，以检验 CPU 设计规范

跳到 9A8，通过验收。

## 2 思考题

### 2.1 在引入 Forwarding 机制后，是否意味着 stall 机制就不再需要了？为什么？

**Answer：** 引入 Forwarding 机制并不意味着不再需要stall机制。Forwarding 机制主要解决数据相关性的问题，通过将计算结果直接转发给需要使用的指令，避免了通过寄存器等中间存储器件的访问延迟。而在遇到结构冲突或控制冲突的时候，需要 stall 机制通过暂停流水线的执行来等待资源可用。并且当所有数据冲突的情况都通过 Forwarding 写回的时候，电路变得复杂，导致需要的时钟周期变长，使用 stall 更能提升性能。

### 2.2 你认为 Forwarding 机制在实际的电路设计中是否存在一定的弊端？和单纯的 stall 相比它有什么缺点？

**Answer:** Forwarding 机制在实际的电路设计中可能存在一定的弊端。首先，引入Forwarding 机制会增加电路的复杂性和功耗。为了实现数据转发，需要添加额外的电路和逻辑来检测和选择需要转发的数据。其次，Forwarding 机制可能会引入更多的时序问题和设计难度，特别是在处理复杂的数据相关性时。相比之下，stall 机制相对简单直观，但需要牺牲一部分性能。

### 2.3 不考虑 AXI4-lite 总线的影响，引入 Forwarding 机制之后 cpi 和 stall 相比提升了那些？

- CPI（Cycles Per Instruction）的降低：通过数据前递，由于数据依赖性导致的 stall 可以通过Forwarding机制解决，避免了流水线的停顿，提高了指令的执行效率。

### 2.4 计算加入 AXI4-lite 总线之后的 cpi，思考 cpi 的值受到什么因素的制约，考虑可能的提升方法？

如果访问外部存储器的延迟较高，内存访问延迟使处理器可能需要等待数据返回，导致流水线暂停，增加CPI。 加入总线之后的 CPI 首 if_stall 信号和 mem_stall 信号影响，可以通过优化内存访问方式，减少内存访问延迟；也可以提高总线的线宽，增加每个时钟周期的数据传输量来提升 CPI。


### 2.5 尝试分析添加 Forwarding 后整体设计的关键路径。
![[lab2implementtimereport.png]]

报告显示从 core 中的 mem 阶段从 alu 出来的结果到得到选择后 pc 的时间最长