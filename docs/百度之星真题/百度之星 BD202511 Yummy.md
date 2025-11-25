---
date: 2025-11-25
title: 码蹄集 OJ 题解：Yummy —— K 进制进位 DP 模型详解
description: 深入解析码蹄集 Yummy 问题的解法。通过分析公式 $\sum s_i v_i k^i = 0$，将问题转化为 K 进制下的“进位消除”模型。利用进位值范围仅为 $\{-1, 0, 1\}$ 的性质，使用线性 DP 反向推导合法方案数。
tags:
  - 算法
  - 动态规划
  - 码蹄集
  - 数学
  - Python
---
[码蹄集OJ-Yummy](https://www.matiji.net/exam/brushquestion/11/4698/91E0C8915821F2C440B65EABFE649804)
给定一个长度为 $n$ 的序列 $s$ 和一个正整数 $k$，其中 $s_i \in \{-1, 1\}$，即 $s_i$ 为 $-1$ 或 $1$。

我们称一个长度为 $n$ 的序列 $v$ 是 Yummy 的，当且仅当序列 $v$ 中的每个元素均为不大于 $k$ 的非负整数，且满足：

$$
\sum_{i=1}^{n} s_i \cdot v_i \cdot k^i = 0
$$

即对于所有不大于 $n$ 的正整数 $i$，$s_i \cdot v_i \cdot k^i$ 之和为 $0$。

你需要求出不同的长度为 $n$ 的 Yummy 的序列 $v$ 的数量。其中，我们称两个长度均为 $m$ 的序列 $a, b$ 是不同的，当且仅当存在至少一个不大于 $m$ 的正整数 $i$ 满足 $a_i \neq b_i$。

由于答案可能很大，所以你只需要求出答案对 $998244353$ 取模的结果。

### 解：
$$
\sum_{i=1}^{n} s_i \cdot v_i \cdot k^i = 0
$$
根据这个公式，可以看成是k进制，往每一位上填数，但是要求最后总和是0
要想这位是0，那计算结果必须是k的整数倍，没有余数
而 每一位/k 的值就是进位值 carry
carry 的取值只有三种情况，1， -1， 0
$$ \text{新进位} = \frac{\text{旧进位} + s_i \cdot v_i}{k} $$
每次v的情况，就根据上一次的进位来补位，补出一个能整除的值
但是，v的情况很多，不能拿来枚举，会超时。然而进位只有三种情况，所以可以枚举进位来反向算出v, 就用上面的进位公式
``` python
import sys

mod = 998244353

data = map(int, sys.stdin.read().split())

iterator = iter(data)

t = next(iterator)

for _ in range(t):

    n, k = next(iterator), next(iterator)

    carries = [-1, 0, 1]  # 用来下标映射

    dp = [0, 1, 0]  # 进位 -1，0，1 的数量

    for _ in range(n):

        new_dp = [0, 0, 0]

        s = next(iterator)

        for j in range(3):  # 遍历上一轮的进位信息

            if dp[j] != 0:  # 若有进位

                old = carries[j]  # 取出进位

                for m in range(3):  # 枚举目标进位

                    c = carries[m]

                    v = (k * c - old) * s  # 反向求v

                    if 0 <= v <= k:  # 看v合不合法

                        new_dp[m] = (new_dp[m] + dp[j]) % mod  # 只有上一轮的进位有用才能累加

        dp = new_dp

    print(dp[1])
```