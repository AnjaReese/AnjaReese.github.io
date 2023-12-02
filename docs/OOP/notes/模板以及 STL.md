[咸鱼暄网课](https://www.bilibili.com/video/BV1va4y1V7Lf/?spm_id_from=333.999.0.0&vd_source=b1094fcb4ee9f427ed2d1f20ed522d33)

[咸鱼暄的代码空间](https://xuan-insr.github.io/cpp/cpp_restart/)

## STL

|组件|描述|
|---|---|
|容器（Containers）|容器是用来管理某一类对象的集合。C++ 提供了各种不同类型的容器，比如 deque、list、vector、map 等。|
|算法（Algorithms）|算法作用于容器。它们提供了执行各种操作的方式，包括对容器内容执行初始化、排序、搜索和转换等操作。|
|迭代器（iterators）|迭代器用于遍历对象集合的元素。这些集合可能是容器，也可能是容器的子集。|

### vector

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

#### 构造：

- 我们可以通过 `vector<int> v;` 的方式构造一个空的、每个元素的类型均为 `int` 的 vector，其名字为 `v`。
- 也可以通过类似 `vector<int> v = {1, 2, 3};` 的方式初始化，这种方式指明了 `v` 初始的元素个数和它们的值。
- 同时，可以通过 `vector<int> v(n);` 的方式构造一个包含 `n` 个元素的 vector。
- 可以通过 `vector<int> v(n, 1);` 的方式构造一个大小为 `n` 且每个元素的值都为 `1` 的 vector。

#### 函数成员

**获取长度**。可以通过 `v.size()` 获取 vector `v` 中的元素个数。

**在末尾插入元素**。可以通过 `v.push_back(x)` 的方式将 `x` 插入到 vector `v` 的末尾。push_back( ) 成员函数在向量的末尾插入值，如果有必要会扩展向量的大小。

**访问（读取 / 修改）元素**。和数组一样，可以通过 `v[i]` 的方式访问 vector `v` 的第 `i` 个元素，下标从 0 开始。注意，当 `i >= v.size()` 的时候，程序可能发生运行时错误。

**capacity** 是指在发生 realloc 前能允许的最大元素数，即预分配的内存空间。

当然，这两个属性分别对应两个方法：resize() 和 reserve()。

- 使用 resize() 容器内的对象内存空间是真正存在的。

- 使用 reserve() 仅仅只是修改了 capacity 的值，容器内的对象并没有真实的内存空间(空间是"野"的)。

