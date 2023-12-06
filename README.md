# One-way-anov
单边检验方差分析
# 目的
检验自变量和因变量是否有联系
## 单边ANOVA分析 - 组间平方和计算

假设我们有 $k$ 个组，样本量分别为 $n_1, n_2, ..., n_k$，总体均值分别为 $\mu_1, \mu_2, ..., \mu_k$。

#### 总体平均值

$$
\bar{X} = \frac{1}{N} \sum_{i=1}^{k} \sum_{j=1}^{n_i} X_{ij}
$$

其中，$N$ 是总样本量。

#### 组间平方和

组间平方和（Between-Groups Sum of Squares）计算如下：

$$
SS_{\text{Between}} = \sum_{i=1}^{k} n_i (\bar{X}_i - \bar{X})^2
$$

其中，$\bar{X}_i$ 是第 $i$ 个组的样本均值，$\bar{X}$ 是总体均值。

#### 误差平方和

误差平方和（Error Sum of Squares）计算如下：

$$
SS_{\text{Error}} = \sum_{i=1}^{k} \sum_{j=1}^{n_i} (X_{ij} - \bar{X}_i)^2
$$

#### 单边ANOVA F 统计量

单边ANOVA的 F 统计量计算如下：

$$
F = \frac{MS_{\text{Between}}}{MS_{\text{Error}}}
$$

其中，$MS_{\text{Between}} = \frac{SS_{\text{Between}}}{k-1}$ 是组间均方，$MS_{\text{Error}} = \frac{SS_{\text{Error}}}{N-k}$ 是误差均方。

#### 决策规则

根据计算得到的 F 统计量和临界值，我们可以进行假设检验，判断是否拒绝原假设。

