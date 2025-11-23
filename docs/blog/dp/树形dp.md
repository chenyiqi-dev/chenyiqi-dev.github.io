---
date: 2025-11-23
参考资料: dp进阶之路   oiwiki
---
也体现了**分治**的思想，第一个子树，第二个子树，......然后合并
由于树固有的递归性质，树形 DP 一般都是**递归**进行的
每一个父亲都是由各个儿子决定的，其实就是**后续遍历**（左右中，自底向上）

树的存储：树的存储不一定是以树的形式，一般是图的形式，邻接表或者链式前向星。所以树形dp是心中有图，实际无图


### 题目1：[P1352 没有上司的舞会 - 洛谷](https://www.luogu.com.cn/problem/P1352)
递归：分为两种情况：1.选当前节点，那就不能选子节点了；2.不选当前节点，那可以选子节点，也可以不选

递归知道了，但是怎么找根节点来开始递归？
	提前用一个数组记录每个节点的父节点，没有父节点就是根节点了

由于树形dp没有重复子问题，所以不能用记忆化搜索

为什么用dp表，不用纯递归返回两个数？
	使用 `dp` 数组是动态规划的标准范式，**便于理解公式、便于调试、便于处理更复杂的后续问题（如输出路径）**
	并且python每次创建一个元组会产生一些开销

本题N比较大，要手动设置递归深度`sys.setrecursionlimit(1000000)`
``` python
import sys  
sys.setrecursionlimit(1000000)  
  
n = int(input())  
r = [0]  
for _ in range(n):  
    r.append(int(input()))  
path = [[] for _ in range(n + 1)]  
is_child = [0] * (n + 1)  # 是否有父节点  
for _ in range(n - 1):  
    l, k = map(int, input().split())  
    path[k].append(l)  
    is_child[l] += 1  
  
for i in range(1, n + 1):  # 找根节点  
    if is_child[i] == 0:  
        root = i  
  
dp = [[0, 0] for _ in range(n + 1)]  
# dp[u][0] = u 不来  
# dp[u][1] = u 来  
  
  
def f(u):  
    dp[u][1] = r[u]  # 选当前的节点  
    for v in path[u]:  
        f(v)  
        dp[u][0] += max(dp[v][0], dp[v][1])  
        dp[u][1] += dp[v][0]  
  
f(root)  
print(max(dp[root][0], dp[root][1]))
```
