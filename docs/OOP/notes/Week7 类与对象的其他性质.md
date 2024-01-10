## 1 类的静态成员

```cpp
static DataType StaticDataName
```

静态数据成员的初始化工作只能在**类外**，并且在**对象生成之前**进行。格式为：

```cpp
DataType ClassName::StaticDataMember = data;
```

1. 静态**数据成员**初始化在类体外进行，而且前面**不加 static** ，以免与一般静态变量或对象相混淆。
2. 初始化时不加该成员的访问权限控制符 private ， public 等。
3. 初始化时使用作用域运算符来标明它所属类，因此，静态数据成员是**类的成员**，而不是对象的成员。

```slide-note
file: [[lecture 4 类与对象的其它特性(4).pdf]]
page: 18, 19
```

静态数据成员在类外需要通过类名进行访问。

```cpp
ClassName::StaticMember; // public
ObjectName.StaticMember; // public
```

```slide-note
file: [[lecture 4 类与对象的其它特性(4).pdf]]
page: 40
```

## 2 友元

静态成员定义提供了同类不同对象数据的共享，属于累内数据共享。 C++ 为了进一步提高数据共享，通过**友元机制**实现类**外数据共享**。

友元不是该类的成员函数，但是可以**访问**该类的**私有成员**。

#### 2.1.1 1 普通函数作为友元函数

```cpp
friend ReturnType FuncName(argvs);
```

- 友元函数为非成员函数，一般在类中进行声明，在类外进行定义；
- 友元函数的声明可以放在类声明中的任何位置，即不受访问权限的控制；
- 友元函数可以通过对象名访问类的所有成员，包括私有成员。

#### 2.1.2 友元类

```cpp
friend class ClassName;
```

- 友元类的声明同样可以在类声明中的任何位置；
- 友元类的所有成员函数将都成为友元函数。

## 3 继承与派生

- 通过继承机制，可以利用已有数据类型来定义新的数据类型。
- 所定义的新的派生类，不仅拥有新定义的成员（数据成员、成员函数），而且还同时拥有旧的基类的成员。

派生类声明：

```cpp
class <派生类名>:<继承方式><派生类成员声明> {
	private:
		派生类成员声明;
	protected:
		...
	public:
		...
}
```

![[Pasted image 20231122091137.png]]

#### 3.1.1 公有继承 public inheritance

- 当类的继承方式为 public （公有），基类的公有成员（ public ）和保护成员 （ protected ）在派生类中保持原有访问属性，其私有成员（ private ）仍为基类私有。
- 派生类类内：可以访问基类中的公有成员和保护成员，而基类的私有成员则不能被访问。
- 派生类类外：只能通过派生类对象访问继承来的基类中的公有成员。

```cpp
#include <iostream>
#include <string>

using namespace std;

class Person{
public:
    Person(string nna="",char nsex='m',string nphonenum=""):name(nna),sex(nsex),phonenum(nphonenum){ }
    void input();
    void output();
private:
    string name;
    char sex;
    string phonenum;
};

void Person::input(){
    cout << "Input name:";
    cin >> name;
    cout << "Input sex:";
    cin >> sex;
    cout << "Input phonenum:";
    cin >> phonenum;
}

void Person::output(){
    cout << "Name:" << name << endl;
    cout << "Sex" << sex << endl;
    cout << "Phonenum:" << phonenum << endl;
}

class Teacher:public Person {
public:
    Teacher(string nna="",char nsex='m',string nphonenum="",string ntitle=""):Person(nna,nsex,nphonenum),title(ntitle){ }
    void input();
    void output();
private:
    string title;
    double salary;
};

void Teacher::input(){
    Person::input();
    cout << "Input title:";
    cin >> title;
    cout << "Input salary:";
    cin >> salary;
}

void Teacher::output(){
    Person::output();
    cout << "Title:" << title << endl;
    cout << "Salary:" << salary << endl;
}

int main(){
    Teacher t;
    t.input();
    t.output();
    return 0;
}
```

#### 3.1.2 私有继承 private inheritance



#### 3.1.3 保护继承 protected inheritance