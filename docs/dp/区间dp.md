---
date: 2025-11-22
title: 区间 DP 学习笔记：石子合并与多边形剖分
description: 详解区间动态规划（Interval DP）的核心思想与代码模版。涵盖如何处理环形问题（断环为链）、枚举区间长度与分界点的技巧。深入分析洛谷 P1880 石子合并与 LeetCode 1039 多边形三角剖分两道经典例题。
tags:
  - 算法
  - 动态规划
  - 区间DP
  - LeetCode
  - Python
cssclasses:
  - dp
---
<!-- more -->
### 区间dp概述
通过枚举**区间分界点**进行转移
这类问题经常有环，环的处理通常两种方法：
1. 加倍
2. 取余
有可能需要提前处理合并区间费用，不要忘记预处理和前缀和

区间dp建议用递归记忆化搜索更符合思考逻辑，因为核心思想是分治，把大问题分成小问题解决
下面两题都是递推想的，非常难想

### 题目1：[P1880 [NOI1995] 石子合并 - 洛谷](https://www.luogu.com.cn/problem/P1880)
注意：这题有环
令f(i, j)表示i,j处理 \[i, j]区间，也就是合并\[i, j]区间的石子，而k是分割点（合并点）
状态转移方程 f(i, j) = max(f(i, k) + f(k + 1,  j)) + sum(i ,  j)
这里k在i，j之间枚举

但是，不能i, j, k 嵌套枚举！
	假设三个for循环嵌套枚举，我们要计算 `dp[1][5]` ,假设分割点 k = 1此时我们需要 `dp[1][1]` 和 **`dp[2][5]`**, 但是`dp[2][5]`还没算，还未知
所以我们枚举区间长度len，这样len为3时，依赖的是len为2和1的，都是已知的
这就是**区间 DP** 的典型特征：**也就是“先解决小区间，再解决大区间”**

要把所有长度为1的区间都置0，`dp_min[i][i] = 0`，因为长度为1不需要合并

最后答案求最大最小值要用`maxm = max(dp_max[i][i+n-1] for i in range(n))`，也就是所有长度正好为 `n` 的连续区间的 dp 值

``` python
from itertools import accumulate  
n = int(input())  
a = list(map(int, input().split()))  
arr = [] + a + a  
sums = list(accumulate(arr, initial=0))  
inf = 0x3f3f3f3f  
  
dp_max = [[0] * (2 * n) for _ in range(n * 2)]  
dp_min = [[inf] * (2 * n) for _ in range(n * 2)]  
for i in range(2 * n):  
    dp_min[i][i] = 0  
for lens in range(2, n + 1):  
    for i in range(0, 2 * n - lens + 1):  
        j = lens + i - 1  
        for k in range(i, j):  
            dp_max[i][j] = max(dp_max[i][j], dp_max[i][k] + dp_max[k + 1][j] + sums[j + 1] - sums[i])  
            dp_min[i][j] = min(dp_min[i][j], dp_min[i][k] + dp_min[k + 1][j] + sums[j + 1] - sums[i])  
  
maxm = max(dp_max[i][i+n-1] for i in range(n))  
minm = min(dp_min[i][i+n-1] for i in range(n))  
  
print(minm)  
print(maxm)
```



### 题目2：[1039. 多边形三角剖分的最低得分](https://leetcode.cn/problems/minimum-score-triangulation-of-polygon/) 
这题和上一题有一些条件上的改变

`dp[i][j]`表示以**i, j 为底**，从i 顺时针到j 的多边形的答案
底边固定了只需要在区间内枚举顶点就好了

**分治：这样就把问题分成了小问题，左边的多边形(i,k为底)小问题 + 当前三角形(i, k, j) + 右边的多边形(k, j为底)小问题**

这题没有环，因为强制选定**底边**作为参考系

为什么固定一条底边？
	因为不管怎么切，每一条边都一定属于某一个三角形
	规定底边 $(0, n-1)$ 的最大好处是：它能保证切分出来的子问题，依然是“连续的”多边形。
	这就是区间 DP 的精髓：**固定端点，枚举分割点**

具体细节：
	k点是共享的，不需要像上一题把k分成k和k + 1
	先把dp表置0，在具体求`dp[i][j]`的时候，再把`dp[i][j]`置inf，可以减少很多初始化的考虑，比如说i, j 是同一点时，`dp[i][j]`要置0，i, j 是相邻两点时，`dp[i][j]`也要置0

``` python
class Solution:

    def minScoreTriangulation(self, values: List[int]) -> int:

        n = len(values)

        dp = [[0] * (n) for _ in range(n)]

  

        for lens in range(3, n + 1):

            for i in range(n - lens + 1):

                j = i + lens - 1

                dp[i][j] = inf

                for k in range(i + 1, j):

                    dp[i][j] = min(dp[i][j], dp[i][k] + dp[k][j] + values[i] * values[k] * values[j])

        return dp[0][n - 1]
```