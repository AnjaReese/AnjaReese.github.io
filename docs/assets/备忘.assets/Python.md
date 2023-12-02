## .CSV to EXCEL

`fprintf` 到一个 `.csv` 文件里，行内逗号分隔

## 最小二乘拟合

[博客：最小二乘拟合用法示例](https://www.cnblogs.com/keye/p/8690183.html)
功能函数 leastsq

### 用法:

```python
scipy.optimize.leastsq(func, x0, args=(), Dfun=None, full_output=0, col_deriv=0, ftol=1.49012e-08, xtol=1.49012e-08, gtol=0.0, maxfev=0, epsfcn=None, factor=100, diag=None)
```

最小化一组方程的平方和。

```python
x = arg min(sum(func(y)**2,axis=0))
         y
```

参数：
   （1）`func：callable`
         应该至少接受一个(可能为N个向量)长度的参数，并返回M个浮点数。它不能返回NaN，否则拟合可能会失败。
          func 是我们自己定义的一个**计算误差的函数**。

   （2）`x0：ndarray`
         最小化的起始估算。
   	     x0 是计算的初始参数值。

   （3）`args：tuple`, 可选参数
         函数的**所有其他参数**都放在此元组中。
 	     args 是指定 func 的其他参数。

**一般我们只要指定前三个参数就可以了。**

   （4）`Dfun：callable`, 可选参数
         一种计算函数的雅可比行列的函数或方法，其中行之间具有导数。如果为None，则将估算雅可比行列式。

   （5）`full_output：bool`, 可选参数
         非零可返回所有可选输出。

   （6）`col_deriv：bool`, 可选参数
         非零，以指定Jacobian函数在列下计算导数(速度更快，因为没有转置操作)。

   （7）`ftol：float`, 可选参数
         期望的相对误差平方和。

   （8）`xtol：float`, 可选参数
         近似解中需要的相对误差。

   （9）`gtol：float`, 可选参数
         函数向量和雅可比行列之间需要正交。

   （10）`maxfev：int`, 可选参数
         该函数的最大调用次数。如果提供了Dfun，则默认 maxfev为100 *(N + 1)，其中N是x0中的元素数，否则默认maxfev为200 *(N + 1)。

   （11）`epsfcn：float`, 可选参数
         用于确定合适的步长以进行雅可比行进的正向差分近似的变量(对于Dfun = None)。通常，实际步长为sqrt(epsfcn)* x如果epsfcn小于机器精度，则假定相对误差约为机器精度。

   （12）`factor：float`, 可选参数
         决定初始步骤界限的参数(factor * || diag * x||)。应该间隔(0.1, 100)。

   （13）`diag：sequence`, 可选参数
         N个正条目，作为变量的比例因子。

   返回值：
   （1）`x：ndarray`
         解决方案(或调用失败的最后一次迭代的结果)。

   （2）`cov_x：ndarray`
         黑森州的逆。 fjac和ipvt用于构造粗麻布的估计值。无值表示奇异矩阵，这意味着参数x的曲率在数值上是平坦的。要获得参数x的协方差矩阵，必须将cov_x乘以残差的方差-参见curve_fit。

   （3）`infodict：`字典
         带有键的可选输出字典：

   （4）`nfev`
         函数调用次数

   （5）`fvec`
         在输出处评估的函数

   （6）`fjac`
         最终近似雅可比矩阵的QR因式分解的R矩阵的排列，按列存储。与ipvt一起，可以估算出估计值的协方差。

   （7）`ipvt`
         长度为N的整数数组，它定义一个置换矩阵p，以使fjac * p = q * r，其中r是上三角形，其对角线元素的幅度没有增加。 p的第j列是单位矩阵的ipvt(j)列。

   （8）`qtf`
         向量(transpose(q)* fvec)。

   （9）`mesg：`力量
         字符串消息，提供有关失败原因的信息。

   （10）`ier：`整型
         整数标志。如果等于1、2、3或4，则找到解。否则，找不到解决方案。无论哪种情况，可选输出变量‘mesg’都会提供更多信息。

      关于leastsq()的说明转载自：https://vimsky.com/examples/usage/python-scipy.optimize.leastsq.html
