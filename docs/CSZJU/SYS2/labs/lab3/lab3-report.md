## 实验步骤

### 准备工程

【重要】 使用 `git`命令从 [上游仓库](https://git.zju.edu.cn/zju-sys/sys2/sys2-fa22) 同步实验代码框架。

```shell
├── Makefile
├── arch
│   └── riscv
│       ├── Makefile
│       ├── include
│       │   ├── defs.h
│       │   └── sbi.h
│       └── kernel
│           ├── Makefile
│           ├── head.S
│           └── sbi.c
├── include
│   ├── print.h
│   └── types.h
├── init
│   ├── Makefile
│   ├── main.c
│   └── test.c
└── lib
    ├── Makefile
    └── print.c
```

本次实验中，同学们需要完善以下文件，实验源代码里添加了错误提示，完成代码后记得将相关的提示清除：

- arch/riscv/kernel/head.S
- lib/Makefile
- arch/riscv/kernel/sbi.c
- lib/print.c
- arch/riscv/include/defs.h


### 编写 head.S 和 vmlinux.lds

对比拉取下来的仓库的 tree 和实验指导中的 tree，发现少了一个 `vmlinux.lds`。实验指导中给出的 vmlinux.lds 分为 4 个段，text, rodata, data, bss, `_end` 指向 bss 段的末尾。

在 `vmlinux.lds` 中添加一个 stack 段，不改变 `_end` 的位置，但设置 stack 段，并且记录栈底地址和栈顶地址。

```lds
.stack : ALIGN(0x1000)  /* .stack 段，4KB 对齐 */
    {
        _stack_bottom = .;  /* 记录栈底的地址为当前地址 */

        *(.stack.entry)  /* 加载 .stack.entry 段的内容 */

        _stack_top = .;  /* 记录栈顶的地址为当前地址 */
    }
    
```

在 `head.S` 中，将设置到栈顶的位置加载到 `sp` 指针，并且在 stack 段开始后，在栈底分配 4KB(4096 字节) 的空间，并且初始化为 0。

```arm-asm
.extern start_kernel

.section .text.entry
.globl _start, _end

_start:
    la sp, _stack_top
    j start_kernel

_end:

.section .stack.entry
.globl _stack_top, _stack_bottom
_stack_bottom:
    // .skip  0x1000
    .space 0x1000 // initialize to 0

_stack_top:

```

### 完善 Makefile 脚本

阅读文档中关于[Makefile](http://127.0.0.1:8000/sys2/sys2-fa23/lab3/#35-makefile)的章节，以及工程文件中的Makefile文件。

完善 lib 目录下的 Makefile，编译所有的 .S 和 .c 文件生成 .o 目标文件

```makefile
# 获取所有的.S文件
ASM_SRC = $(sort $(wildcard *.S))
# 获取所有的.c文件
C_SRC = $(sort $(wildcard *.c))
# 生成目标文件列表，将.S文件和.c文件分别替换为.o文件
OBJ = $(patsubst %.S,%.o,$(ASM_SRC)) $(patsubst %.c,%.o,$(C_SRC))

# 默认目标，编译所有目标文件
all: $(OBJ)

# 生成.o文件的规则，依赖于同名的.S文件
%.o: %.S
	${GCC} ${CFLAG} -c $<

# 生成.o文件的规则，依赖于同名的.c文件
%.o: %.c
	${GCC} ${CFLAG} -c $<

# 清理目标文件
clean:
	$(shell rm *.o 2>/dev/null)
```

### 补充 `sbi.c`

OpenSBI在M态，为S态提供了多种接口，比如字符串输入输出。 因此我们需要实现调用 OpenSBI 接口的功能。给出函数定义如下：

`sbi_ecall` 函数中，需要完成以下内容：

1. 将 ext(Extension ID) 放入寄存器 a7 中，fid(Function ID) 放入寄存器 a6 中，将arg[0-5]放入寄存器a[0-5]中。
2. 使用`ecall`指令。`ecall`之后系统会进入M模式，之后OpenSBI会完成相关操作。
3. OpenSBI 的返回结果会存放在寄存器 a0、a1 中，其中 a0 为 error code，a1为返回值，我们用 sbiret 结构来接受这两个返回值。

```c
    struct sbiret ret;

    __asm__ volatile(
      "mv a7,  %[ext]\n"
      "mv a6,  %[fid]\n"
      "mv a0, %[arg0]\n"
      "mv a1, %[arg1]\n"
      "mv a2, %[arg2]\n"
      "mv a3, %[arg3]\n"
      "mv a4, %[arg4]\n"
      "mv a5, %[arg5]\n"
      "ecall\n" // use ecall instruction to call SBI
      "mv %[ret_error], a0\n"
      "mv %[ret_value], a1\n"
      : [ret_error]"=r"(ret.error), [ret_value]"=r"(ret.value) // use ret struct to receive the 2 return values
      : [ext]"r"(ext), [fid]"r"(fid), [arg0]"r"(arg0), [arg1]"r"(arg1), [arg2]"r"(arg2), [arg3]"r"(arg3), [arg4]"r"(arg4), [arg5]"r"(arg5)  // pass the arguments to SBI
      : "memory", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
    );

    return ret;

}
```

在这段代码中，如果在第四部分受影响的寄存器与内存中不加入 a0-a7，会导致传参默认使用 a0-a7，在汇编中的指令实际上成为：

```arm-asm
mv a7, a6
mv a6, a7
mv a0, a5
mv a1, a4
mv a2, a3
mv a3, a2
mv a4, a1
mv a5, a0
```

实际上存 fid 的地方被 ext 覆盖了，其他参数的传递也有问题，但是由于传递的参数很多是 0，所以能跑通。但是 `"mv a7,  %[ext]\n"` 和 `"mv a6,  %[fid]\n"` 的相对顺序一旦调换，就无法正常显示出字符串。

百思不得其解最后发现添加可能受影响的寄存器不仅仅是优化用的。添加之后传参就会避开这些需要使用的寄存器了。怒交一份 Pull request 把示例代码的受影响寄存器也加上了。

|Function Name|Function ID|Extension ID|
|---|---|---|
|sbi_set_timer （设置时钟相关寄存器）|0|0x00|
|sbi_console_putchar （打印字符）|0|0x01|
|sbi_console_getchar （接收字符）|0|0x02|

```c
void sbi_set_timer(uint64 stime_value) { //set timer
    sbi_ecall(0x00, 0, stime_value, 0, 0, 0, 0, 0);
}

void sbi_console_putchar(int ch) { // send character
    sbi_ecall(0x01, 0, ch, 0, 0, 0, 0, 0);
}

int sbi_console_getchar() { // reveive character
    struct sbiret ret;
    ret = sbi_ecall(0x02, 0, 0, 0, 0, 0, 0, 0);
    return ret.error;
}
```


### `puts()` 和 `puti()`

调用以上完成的`sbi_ecall`, 完成`puts()`和`puti()`的实现。`puts()`用于打印字符串`puti()`用于打印整型变量。

请编写`lib/print.c`中的`puts()`和`puti()`，函数的相关定义已经写在了`print.h`文件。

```c
void puts(char *s) {
  while (*s != '\0') {
        sbi_console_putchar(*(s++));
    }
}
```

```cpp
void puti(int x) {
    int temp = x;
    int i = 1;

    if (x == 0) {
        sbi_console_putchar('0');
        return;
    } else if (x < 0) {
        sbi_console_putchar('-');
        x *= -1;
    }

    while (temp != 0) {
        i *= 10;
        temp = temp / 10;
    }
    while (x != 0) {
        i /= 10;
        sbi_console_putchar('0' + x / i);
        x = x % i;
    }
}
```

### 修改 defs

学习了解了内联汇编的相关知识后，补充 `arch/riscv/include/defs.h` 中的代码，完成 `read_csr` 宏定义。

```c

#define csr_read(csr) ({ __asm__ volatile ("csrr " #csr ", %0":"=r" (csr) :: "memory");})

#define csr_write(csr, val) ({ __asm__ volatile ("csrw " #csr ", %0":: "r" (val): "memory");})

```

完成完以上内容后再次执行 make，可以看到在根目录下成功生成了vmlinux。

运行 make run 即可执行，正确地打印出了欢迎信息`2022 ZJU Computer System II`。

![[sys2lab3finish.png]]

s## 思考题

1. 编译之后，通过System.map查看vmlinux.lds中自定义符号的值，比较他们的地址是否符合你的预期

![[sys2lab3sysmap.png.png]]

由于 data, bss 中没有数据，所以它们的地址是一样的。而 `_start` 和 `_end` 之间有 8 字节，`_end` 之后我自定义的栈有 4 字节，符合预期。

- bss, data, rodata 段均标记为 R (只读)
- text 及代码段中的⼀些函数标记为 T (代码段)
- `_stack_bottom` 和 `_stack_top` 构成的 stack 段为自定义，标记为 N

2. 在你的第一条指令处添加断点，观察你的程序开始执行时的特权态是多少，中断的开启情况是怎么样的？
    - **提示**：可以尝试在第一条指令处插入一些特权操作，如`csrr a0, mstatus`，观察调试现象，进行当前特权态的判断

![[sys2lab3think2bri.png]]

在开头下断点，运行到 `_start` 处，查看 priv 寄存器，观察到特权态是 为 1，表示 Supervisor。且 mie 寄存器的值是 8，表⽰中断开启。

3. 在你的第一条指令处添加断点，观察内存中text、data、bss段的内容是怎样的？

text 段：
   ![[sys2lab3textpart.png]]

data 段：

![[sys2lab3datapart.png]]

bss 段：没有内容

![[sys2lab3bsspart.png]]

4. 尝试从汇编代码中给C函数 start_kernel 传递参数

默认用 a0 传参数，在 `head.S` 跳转指令前添加 `li a0, 立即数`，在 `main.c` 的 start_kernel 函数中传参即可。

![[sys2lab3lia0.png]]

![[sys2lab3phantom1003.png]]

