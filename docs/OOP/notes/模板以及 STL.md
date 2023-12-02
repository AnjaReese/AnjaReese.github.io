https://www.bilibili.com/video/BV1va4y1V7Lf/?spm_id_from=333.999.0.0&vd_source=b1094fcb4ee9f427ed2d1f20ed522d33

https://xuan-insr.github.io/cpp/cpp_restart/)

## STL

|组件|描述|
|---|---|
|容器（Containers）|容器是用来管理某一类对象的集合。C++ 提供了各种不同类型的容器，比如 deque、list、vector、map 等。|
|算法（Algorithms）|算法作用于容器。它们提供了执行各种操作的方式，包括对容器内容执行初始化、排序、搜索和转换等操作。|
|迭代器（iterators）|迭代器用于遍历对象集合的元素。这些集合可能是容器，也可能是容器的子集。|

### Container

#### vector

向量在需要扩展大小的时候，会自动处理它自己的存储需求：

```cpp
#include <iostream>
#include <vector>
using namespace std;
 
int main()
{
   // 创建一个向量存储 int
   vector<int> vec; 
   int i;
 
   // 显示 vec 的原始大小
   cout << "vector size = " << vec.size() << endl;
 
   // 推入 5 个值到向量中
   for(i = 0; i < 5; i++){
      vec.push_back(i);
   }
 
   // 显示 vec 扩展后的大小
   cout << "extended vector size = " << vec.size() << endl;
 
   // 访问向量中的 5 个值
   for(i = 0; i < 5; i++){
      cout << "value of vec [" << i << "] = " << vec[i] << endl;
   }
 
   // 使用迭代器 iterator 访问值
   vector<int>::iterator v = vec.begin();
   while( v != vec.end()) {
      cout << "value of v = " << *v << endl;
      v++;
   }
 
   return 0;
}
```

##### 构造：

- 我们可以通过 `vector<int> v;` 的方式构造一个空的、每个元素的类型均为 `int` 的 vector，其名字为 `v`。
- 也可以通过类似 `vector<int> v = {1, 2, 3};` 的方式初始化，这种方式指明了 `v` 初始的元素个数和它们的值。
- 同时，可以通过 `vector<int> v(n);` 的方式构造一个包含 `n` 个元素的 vector。
- 可以通过 `vector<int> v(n, 1);` 的方式构造一个大小为 `n` 且每个元素的值都为 `1` 的 vector。

##### 函数成员

- `empty()`; //判断容器是否为空
- `capacity()`; //容器的容量
- `size()`; 可以通过 `v.size()` 获取 vector `v` 中的元素个数。
- `resize(int num)`; 重新指定容器的长度为num，若容器变长，则以默认值填充新位置。如果容器变短，则末尾超出容器长度的元素被删除。
- `resize(int num, elem)`; 重新指定容器的长度为num，若容器变长，则以elem值填充新位置。
- 使用 `reserve() `仅仅只是修改了 capacity 的值，容器内的对象并没有真实的内存空间(空间是"野"的)。
-  `v.push_back(x)` 的方式将 `x` 插入到 vector `v` 的末尾。push_back( ) 成员函数在向量的末尾插入值，如果有必要会扩展向量的大小。
- `push_back(ele)`; 尾部插入元素ele
- `pop_back()`; 删除最后一个元素
- `insert(const_iterator pos, ele)`;  迭代器指向位置pos插入元素ele
- `insert(const_iterator pos, int count,ele)`;  迭代器指向位置pos插入count个元素ele
- `erase(const_iterator pos)`; 删除迭代器指向的元素
- `erase(const_iterator start, const_iterator end)`; 删除迭代器从start到end之间的元素
- `clear()`; 删除容器中所有元素;
- `v1.swap(v2)`; 互换两个容器中的元素
- `v1.at(i)`, `v1.front()`, `v1.back()`；访问第 i 个，第 0 个，最后一个元素
- `emplace()`, 在指定位置直接生成一个元素，会把原先的元素覆盖
- `begin()`, 返回指向第一个元素的迭代器
- `end()`, 返回指向最后一个元素后一个位置的迭代器
- `rbegin()`, 返回指向最后一个元素的迭代器
- `rend()`, 返回指向第一个元素前一个位置的迭代器
- `emplace_back()`

**访问（读取 / 修改）元素**。和数组一样，可以通过 `v[i]` 的方式访问 vector `v` 的第 `i` 个元素，下标从 0 开始。注意，当 `i >= v.size()` 的时候，程序可能发生运行时错误。

#### deque

- `push_back()`
- `pop_back()`
- `push_front()`
- `pop_front()`
- `emplace_front()`, 在开头直接生成一个元素，会把原先的元素覆盖

#### stack

#### queue

#### priority_queue

https://en.cppreference.com/w/cpp/container/priority_queue

```cpp
template<
    class T,
    class Container = std::vector<T>,
    class Compare = std::less<typename Container::value_type>
> class priority_queue;
```

e.g: 最小堆

```cpp
priority_queue<int, vector<int>, greater<int>> cache;
```

### Algorithm

#### sort

```cpp
#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

int main()
{

    int s[] = {5, 7, 4, 2, 8, 6, 1, 9, 0, 3};
    vector<int> v = {5, 7, 4, 2, 8, 6, 1, 9, 0, 3};

    sort(s, s + 10);
    for (int i : s) 
        cout << i << " ";
    cout << endl;

    sort(v.begin(), v.end(), greater<int>());
    for (int i : v) 
        cout << i << " ";
    cout << endl;
}
```


