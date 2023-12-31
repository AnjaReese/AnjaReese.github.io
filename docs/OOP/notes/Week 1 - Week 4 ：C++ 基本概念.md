 
## 两周后在 pta 开展教学班

类的定义，类成员的实现，主函数实现；小程序可以写在一个文件中
## C++ 基本定义
### 1 什么是命名空间

- 命名空间（namespace）是一种特殊的作用域，可以将不同的标识符集合在一个命名作用域内，这些标识符可以是类、对象、函数、变量、结构体、模板以及其他命名空间等。在作用域范围内使用命名空间就可以访问命名空间定义的标识符。
- 命名空间的使用目的是为了将逻辑相关的标识符限定在一起，组成相应的命名空间，可使整个系统更加模块化，最重要的是它可以防止命名冲突。命名空间是用来组织和重用代码的编译单元。
- 有了命名空间，标识符就被限制在特定的范围内，在不同的命名空间中，即使使用同样的标识符表示不同的事物，也不会引起命名冲突。

### 4 引用

```slide-note
file: [[lecture 2 C++基础(4).pdf]]
page: 53, 57-60
```

### 5 函数

#### 5.2 重载函数：

```slide-note
file: [[lecture 2 C++基础(4).pdf]]
page: 71
```

(1)重载函数必须具有不同的参数个数或不同的参数类型，若只是返回值的类型不同或形参名不 同是错误的。
(2)匹配重载函数的顺序:首先寻找一个精确匹配，如果能找到，调用该函数;其次进行提升匹 配，通过内部类型转换(窄类型到宽类型的转换)寻求一个匹配，如char到int、short到int等， 如果能找到，调用该函数;最后通过强制类型转换寻求一个匹配，如int到double等，如果能找到 ，调用该函数。
#### 5.3 默认参数

- C++中允许函数提供默认参数，也就是允许在函数的声明或定义时给一个 或多个参数指定默认值。
- 在调用具有默认参数的函数时，如果没有提供实际参数，C++将自动把默 认参数作为相应参数的值。

(1) 当函数既有原型声明又有定义时，默认参数只能在**原型声明中指定**，而不能在函数定义中指定。如果一个函数的定义先于其调用，没有函数原型，若要指定参数默认值，需要在定义时指定。

(2) 在函数原型中，所有取默认值的参数**都必须出现在不取默认值的参数的右边**。也就是一旦某个参数开始指定默认值，其右面的所有参数都必须指定默认值，遵循从右至左的规则。

(3) 在调用具有默认参数值的函数时，若某个实参默认而省略，则其**右面的所有实参皆应省略而采用默认值**。不允许某个参数省略后，再给其右面的参数指定参数值，遵循从左至右的规则。

(4) 当函数的重载带有默认参数时，要注意避免二义性。例如:定义如下两个重载函数: 
```cpp
double add(double x,double y=2.2);  
double add(double x); 
```
这是错误的，因为如果有调用函数add(2.5)时，编译器将无法确定调用哪一个函数。

(5) 函数的带默认参数值的功能可以在一定程度上简化程序的编写。

#### 5.4 内联函数

内联函数声明或定义时，将 inline 关键字加在函数的返回类型前面就可以将函数定义为内联函数。

- 函数使用有利于代码重用，提高开发效率，增强程序的可靠性，便于分工合作，便于修 改维护。

- 函数的调用会降低程序的执行效率，需要保存和恢复现场和地址。需要时间和空间的开 销。为解决这一问题，C++中对于功能简单、规模小、使用频繁的函数，可以将其设置为内联函数。

- 内联函数(inline function)的定义和调用和普通函数相同，但C++对它们的处理方式不一 样。如果一个函数被定义为内联函数，**在编译时，C++将用内联函数代码替换对它每次的调用。**

> 优点: **节约时间**。内联函数没有函数调用的开销，即节省参数传递、控制转移的开销，从而提高了程序运行时的效率。
>
   缺点: **增大空间**。由于每次调用内联函数时，只是将这个内联函数的所 有代码复制到调用函数中，所以会增加程序的代码量，占用更多的存储 空间，增大了系统空间方面的开销。
>
   因此，内联函数是一种以空间换时间的方案。

(1) 内联函数体内不能有循环语句和switch语句。递归调用的函数不能定义为内联函数。
(2) 内联函数的声明必须出现在内联函数第一次被调用之前。
(3) 内联函数代码不宜太长，一般是1~5行代码的小函数，调用频繁的简单函 数可以定义为内联函数。
(4) 在类内定义的成员函数被默认为内联函数。

#### 5.5 引用参数和返回引用

引用只须传递一个对象的地址，可以提高函数的调用和运行效率效率。 C++中，引入引用主要用于定义函数参数和返回值类型。

##### 5.5.1 引用参数

使用引用参数，一般在下面的几种情况下使用:

(1) 需要从函数中返回多于一个值;

(2) 修改实参值本身;

(3) 传递地址没有传值和生成副本的空间和时间消耗。 提高函数调用和运行效率。

##### 5.5.2返回引用

C++中，函数除了能够返回值或指针外，也可以返回一个引用。 返回引用的函数定义格式如下:

返回值类型 & 函数名(形参表)

当一个函数返回引用时，实际是返回了一个**变量的地址**，这使函数调用能够出现在赋值语句的左边。

### 6 变量的作用域与可见行

- 作用域讨论的是标识符的有效范围。
- 可见性是讨论标识符是否可以被使用。

#### 命名空间作用域

```cpp
using <命名空间名>::<标识符>;
using namespace <命名空间>;
```

	前一种形式将指定的标识符释放在当前的作用域内，使得在当前作用域中 可以直接引用该标识符；后一种形式将指定命名空间的所有标识符释放在当前 的作用域内，使得在当前作用域中可以直接引用该命名空间内的任何标识符。

#### 命名空间可见性

（1）标识符要**声明在前**，**引用在后**。 
（2）在同一作用域中，不能声明同名的标识符。 
（3）在没有相互包含关系的不同的作用域中声明的同名标识符，互不影响。 
（4）如果在两个或多个具有包含关系的作用域中声明了**同名**标识符，则**外层标识符在内层不可见**。

### 7 对象生存期

> 所谓对象的生存期是指对象从被创建开始到被释放为止的时间。
	- 静态生存期
	- 动态生存期

1. 静态生存期（Static Lifetime）：
    
    - 静态生存期的对象在程序的**整个运行期间都存在**。
    - 静态生存期的对象在程序启动时被创建，并在程序结束时销毁。
    - 静态生存期的对象通常在全局作用域内定义，或者在类的静态成员变量中定义。
    - 静态生存期的对象具有静态存储持续性（static storage duration）。
    - 静态生存期的对象在内存中分配一次，直到程序结束才会释放。

2. 动态生存期（Dynamic Lifetime）：
    
    - 动态生存期的对象在程序运行时动态地创建和销毁。
    - 动态生存期的对象通过使用 `new` 运算符在堆（heap）上分配内存，并通过 `delete` 运算符释放内存。
    - 动态生存期的对象具有动态存储持续性（dynamic storage duration）。
    - 动态生存期的对象的生命周期由程序员显式控制，可以在任意时刻创建和销毁。

### 8 const 常量

>  常量是一种标识符，它的值在运行期间恒定不变。 
>  C语言用 `#define` 来定义常量（称为宏常量）。
>  C++ 语言除了用 `#define` 定义常量外，还可以用 const 来定义常量 （称为 const 常量）。

```cpp
const <常量类型> <常量名>=<常量值>
const int i = 10;
const char c = 'A';
const char a[] = 'C++ const';
```

常量一**经定义就不能修改**，并且必须在**定义时初始化**。

#### 8.1 const 的使用

- 在C++中，表达式可以出现在常量定义语句中。例如： 

```cpp
int a=4,b; const int b=a+55;
```

- 在另一连接文件中引用const常量

```cpp
extern const int i;      // 合法
extern const int i = 10; // 不合法，常量不可以被再次赋值
```

（1）需要对外公开的常量放在头文件中，不需要对外公开的常量放在定义文件的头部。为便于 管理，可以把不同模块的常量集中存放在一个公共的头文件中
（2）如果某一常量与其它常量密切相关，应在定义中包含这种关系，而不应给出一些孤立的值 。例如：

```cpp
const float RADIUS = 100;
const float DIAMETER = RADIUS * 2;
```

const 可以与指针、函数的参数和返回值、类的数据成员和成员函数等 结合起来，定义常量指针，函数的参数和返回值为常量以及常对象，常 数据成员、常成员函数等。

const常量有数据类型，而宏常量没有数据类型。编译器可以对前者进行类型安全检查。而对后者只进行字符替换，没有类型安全检查，并且在字符替换可能会产生意料不到的错误。

#### 8.2 const 修饰指针变量

- A: const 修饰指针指向的内容，则内容为不可变量。
- B: const 修饰指针，则指针为不可变量。
- C: const 修饰指针和指针指向的内容，则指针和指针指向的内容都为不可变量。

## 10 编译预处理

## 11 文件的输入输出

> C++ 的文件操作是首先通过将 ifstream、ofstream、fstream 流类的对象与某个磁盘文件联系起来，创建一个文件流，然后调用这些类的成员函数实现文件的打开、读写和关闭操作

- ofstream 类：输出文件类（写操作），从 ostream 类派生而来。 
- ifstream 类：输入文件类（读操作），从 istream 类派生而来。 
- fstream 类：可同时输入输出的文件类（读写操作），从 iostream 类派生而来。

### 11.1 打开或关闭磁盘文件

```cpp
文件流对象.open(磁盘文件名, 文件打开模式);
```

文件的打开模式可以是： 
- ios::in 打开一个输入文件（默认方式）。
- ios::out 建立一个输出文件（默认方式），如果此文件已存在，则将原有内容删除 。 
- ios::app 若文件存在，将数据被追加到文件的末尾，若不存在，就建立文件。
- ios::ate 打开文件时，文件指针位于文件尾。 
- ios::trunk 删除文件原来已存在的内容（清空文件）。 
- ios::nocreate若文件并不存在，打开操作失败。
- ios::noreplace若文件已存在，打开操作失败。
- ios::binary以二进制的形式打开一个文件，缺省时按文本文件打开。

```cpp
ios:app OR ios:binary
// 设置不止一个的打开模式标志，只须使用“OR”操作符或者是“ |”
```

```cpp
ofstream outData;
outData.open("C:\\EF\\aa.txt", ios:app);
// 若文件存在就打开，若不存在就建立该文件
```

关闭磁盘文件：

```cpp
文件流对象.close()
```

### 11.2 文件的输入和输出

```cpp
#include <fstream> // 首先在程序包含头文件fstream

ifstream inData; // 定义文件流变量
ofstream outData;

outData.open("C:\\EF\\aa.txt", ios:app); //使用open()函数将文件流变量与磁盘文件关联起来

// 用文件流变量和“<<”或“>>”结合读写文件数据
// 关闭文件
```

```cpp
#include <fstream>
#include <iostream>
#include <string>

using namespace std;
int main() {
	string str1, str2;
	ofstream outstr;
	ifstream instr;
	outstr.open("./a.txt", ios::out);
	if (!outstr) {
	cerr<<"open failed!";
	return -1;
	}
	str1 = "555";
	outstr << str1;
	outstr.close();
	return 0;
}
```