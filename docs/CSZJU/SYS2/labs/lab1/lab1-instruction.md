# Lab1：基于 stall 的五级流水线

## 实验目的

- 理解流水线的基本概念与思想
- 理解数据竞争、控制竞争、结构竞争的原理和解决方法
- 基于在单周期 CPU 中已经实现的模块，实现 5 级流水线框架
- 加入冲突检测模块和 stall 执行模块解决竞争问题
- 理解流水线设计在提高 CPU 的吞吐率，提升整体性能上的作用与优越性

## 实验要求

在 SCPU 的基础上加入中间寄存器实现五级流水线 CPU，处理器要求支持 RV64I 指令集并加入竞争检测机制和 stall 执行机制，解决三种竞争。此外，使用 BRAM 代替原先的 DRAM。

RISC-V 相关的指令可以在[官网](https://riscv.org/technical/specifications/)上找到相应的编码信息和介绍。
也可以查询[RISC-V 非特权指令集手册](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf)。

要求实现的指令列表如下：

- [ ] lui, auipc
- [ ] jal, jalr
- [ ] beq, bne, blt, bge, bltu, bgeu
- [ ] lb, lh, lw, lbu, lhu, lwu, ld, sb, sh, sw, sd
- [ ] addiw, slliw, srliw, sraiw
- [ ] addw, subw, sllw, srlw, sraw
- [ ] addi, slti, sltiu, xori, ori, andi, slli, srli, srai
- [ ] add, sub, sll, slt, sltu, xor, srl, sra, or, and

### 实验步骤

1. 根据参考设计图或自己设计的设计图搭建完整的流水线加法机，继续使用 Nexys7 对应的外设进行实验，实现 lab1 的带 stall 的五级流水线替换 lab0 中的 CPU 模块。Memory 使用提供的 RAM.v 模块，**但请不要修改除了初始化文件以外的代码部分**；
2. 在本实验中不要求对数据通路进行专门的封装，推荐直接将 Control Unit (Decoder) 视为译码模块放在 ID 段中；
3. 进行仿真测试，以检验 CPU 基本功能；
4. 调整时钟频率，确保时钟周期长度不小于最长流水段的信号延迟；
5. 进行上板测试，以检验 CPU 设计规范，上板测试调试工具相关内容请参考 lab0。

### 实验建议

1. **RAM.v 模块的使用**：建议大家在完成 PipelineCPU 内部连线的时候，将 RAM.v 模块以外的所有模块封装为单独的 Core.v 模块，然后 Core.v 和 RAM.v 模块在进行连线，这样在我们后续 lab2 将 RAM.v 模块替换为更复杂的总线连接的内存模块的时候的时候，可以不需要做过多的调整。
2. **stall-flush 的接口问题**：建议每个中间寄存器 IF/ID、ID/EXE、EXE/MEM、MEM/WB 都有面向冲突处理的接口 stall 和 flush，前者负责处理停顿，后者负责处理刷新；对于发出 stall 和 flush 控制信号的模块建议对每个中间寄存器都发出独立的 stall 和 flush 信号，例如下面的接口样式：

```verilog
RaceController(
    ....
    output wire stall_PC,
    output wire stall_IFID,
    output wire stall_IDEXE,
    output wire stall_EXEMEM,
    output wire stall_MEMWB,
    output wire flush_IFID,
    output wire flush_IDEXE,
    output wire flush_EXEMEM,
    output wire flush_MEMWB
);
```

> 这些预留的接口有利于后续冲突处理的扩展，大家在 lab2 马上就可以体会到了。

3. **Verilator 测试相关**。不同于 SCPU 每个周期只运行一条指令， PipelineCPU 是 5 条指令一起运行的，但是只有 WB 阶段输出的结果才是最后指令运行完毕提交的结果，所以在进行 testbench.v 测试的时候需要把 WB 的 PC、inst、rd_id、rd_we、rd_data 输出出去。考虑到 stall 会插入无效的中间指令，所以建议每个中间寄存器加一个 valid 状态，只有指令有效的时候 valid=1 ，然后将 valid 一并发送到 cosim.v 中去，这样只有有效合法的指令才会被 cosim.v 模拟检测，而 stall 引入的无效指令不会影响 cosim.v 的检测工作；
4. **命名与接线的小技巧**：Verilog 连线是一件费时费力的机械劳动，掌握一些命名和接线的技巧有利于提高连线的效率和准确率。建议每个流水级内部的线都加一个对应流水级的后缀，比如 ID 阶段的 PC 命名为 PC_ID，EXE 阶段的 PC 命名为 PC_EXE，可以防止接线的时候名字记混。模块连线的时候建议沿着流水级的拓扑顺序进行连线，比如以 PC-IFID-{Ctrl,RegFile,ImmGen}-IDEXE-...这样的顺序开始声明模块和连线，这样大多数模块只需要在连线之前声明自己输出的线即可，而输入的线在声明上游模块输出线的时候已经声明好了，声明的线也可以快速连接自己的输入输出，防止错连、漏连、线的重复定义和未定义。最后注意定义的线宽，不然忘记定义线宽。

## 思考题

1. 对于 test1（4-15 行），请计算你的 CPU 的 CPI，再用 lab0 的单周期 CPU 运行 test1，对比二者的 CPI；
2. 对于 test2（17-52 行），请计算你的 CPU 的 CPI，再用 lab0 的单周期 CPU 运行 test2，对比二者的 CPI；
3. 请你对数据冲突,控制冲突情况进行分析归纳，试着将他们分类列出；
4. 如果 EX/MEM/WB 段中不止一个段的写寄存器与 ID 段的读寄存器发生了冲突，该如何处理？
5. 如果数据冲突和控制冲突同时发生应该如何处理呢？
6. 能否使用 BRAM 来实现寄存器组？
7. 尝试分析整体设计的关键路径。
