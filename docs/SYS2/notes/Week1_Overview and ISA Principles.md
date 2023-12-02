slide: ![[lec01-1(1).pdf]]

----

```slide-note
file: lec01-1(1).pdf
page: 5
scale: 1
dpi: 2
text: true
```

----

```slide-note
file: [[lec01-1(1).pdf]]
page: 8
scale: 1
dpi: 2
text: true
```


> [!Note] with **attendence** as bonus

## Instruction Set Principles

### Architectures

```slide-note
file: [[SYS2/slides/lec01-2(1).pdf]]
page: 9
```

- Stack Architecture
- Accumulator Architecture
- Register-Memory Architecture

> [!Note] e.g. D = A \* B - (A + C \* B)


#### **Stack** Architecture 

- **Implicit Operands** : on the Top Of the Stack (TOS)
- Simple example: 98 * (12 + 45) 

```assembly
PUSH 98
PUSH 12
PUSH 45
ADD
MUL
```

```assembly
push A
push B
mul
push A
push C
push B
mul
add
sub
pop  D
```

#### Accumulator Architecture

- **One implicit operand**: the accumulator 
- **One explicit operand**: mem location
- Accumulator is both an **implicit input** operand and a **result**

```assembly
load  B
mul   C
add   A
store D
load  A
mul   B
sub   D
store D
```

#### Register-Memory Architectures

```assembly
load  R1, A
mul   R1, B
load  R2, C
mul   R2, B
add   R2, A
store R2, D
sub   R1, D
store R1, D
```

#### Register Operands

```slide-note
file: [[lec01-2(1).pdf]]
page: 36
```

Memory Operand Examples

```slide-note
file: [[SYS2/slides/lec01-2(1).pdf]]
page: 38
```

#### Caller Saving and Callee Saving P484

```slide-note
file: [[SYS2/slides/lec01-2(1).pdf]]
page: 52-53
```

叶子过程示例

```slide-note
file: [[SYS2/slides/lec01-2(1).pdf]]
page: 54
```

```slide-note
file: [[SYS2/slides/lec01-2(1).pdf]]
page: 25
```

