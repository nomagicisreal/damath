
<details>
    <summary>index</summary>

[descriptive](#descriptive)\
[inferential](#inferential)\
[estimation](#estimation)

</details>

---
## descriptive
### variable
- qualitative variables | quantitative variables (discrete|continuous)
- dummy variables
- measurement level (nominal level | ordinal level | interval level | ratio level)

### table | chart | diagram
- univariate
  - frequency table (including time, time/total)
    - cumulative frequency table (line chart)
    - classed frequency table
      - determine k class (2^k ≥ total)
      - determine i class interval (i ≥ (max - min) / k)
      - approach quantitative equality for each class (i.e. 1 ≤ g1 < 100, 101 ≤ g2 < 200, 201 ≤ g3 < 300...)
  - other charts (bar | pie | histogram/dot | line)
- bivariate | multiple variate
  - scatter diagram (require interval level)
  - contingency table

### measures of location
- arithmetic mean:
  - for population: $µ = \cfrac{∑ x}{N}$
  - for sample:     $\bar{x} = \cfrac{∑x}{n}$
  - for classed sample: $\bar{x}_c = \cfrac{∑(n_{c} \cdot µ_c)}{n}$
  - weighted: $\bar{x}_w = \cfrac{∑(x \cdot w_i)}{∑w_i}$
- geometric mean: $GM = \sqrt[n]{x_1 \cdot x_2 \cdot ... \cdot x_n}$
- median:
  - $\forall n \in Odd, m = x_{\lceil \frac{n}{2}\rceil}$
  - $\forall n \in Even, m = \cfrac{x_\frac{n}{2} + x_{\frac{n}{2} +1}}{2}$
- quartiles | deciles | percentiles:
  - $tiles \in \{4, 10, 100\}, L_t = \cfrac{(n + 1) \cdot t}{tiles}$
  - interquartile range: $q = Q_3 - Q_1$,
  - $∃ outlier \implies ¬∀ (Q_1 - 1.5r ≤ observations ≤ Q_3 + 1.5r$)
  - box plot is used for quartiles
- mode
- skewness
  - positively skewed (mode ≤ median ≤ mean)
  - negatively skewed (mean ≤ median ≤ mode)
- bimodal distribution, ...

### measures of dispersion
  - range = $x_{max} - x_{min}$
  - variance
    - for population: $σ^2 = \cfrac{∑(x - µ)^2}{N}$
    - for sample    : $s^2 = \cfrac{∑(x - \bar{x})^2}{n - 1}$
  - standard deviation
    - for population    : $σ = \sqrt{\cfrac{∑(x - µ)^2}{N}}$
    - for sample        : $s = \sqrt{\cfrac{∑(x - \bar{x})^2}{n - 1}}$
    - for classed sample: $s = \sqrt{\cfrac{∑(n_c \cdot (mean_{class} - \bar{x}))^2}{n - 1}}$

### appendix
- Pearson's coefficient of skewness: $sk = \cfrac{3(\bar{x} - median)}{s}$
- increasing rate by time = $\sqrt[period]{(final / initial) - 1}$
- Chebyshev theorem:
  - ∀ population|sample,
  - ∃ $N \cdot (1 - \frac{1}{k^2})$ observations,
  - µ - kσ ≤ observations ≤ µ + kσ.
- Normal Rule: ??
  - ∀ population|sample in symmetrically bell shape
  - ∃ 68% observations, µ - σ ≤ observations ≤ µ + σ.
  - ∃ 95% observations, µ - 2σ ≤ observations ≤ µ + 2σ.
  - ∃ 99.7% observations, µ - 3σ ≤ observations ≤ µ + 3σ, $\frac{range}{6}$ ≈ σ

---
## inferential
probability in statistic: experiment, outcome, event (mutually exclusive events, collectively exhaustive events)

### probability types:
  - classical probability: $P_{event} = \cfrac{N_{event}}{ N_{all}}$
  - empirical probability: $P_{event} = \cfrac{N_{experienced}}{N_{observations}}$
  - objective probability vs subjective probability:
  - conditional probability
  - prior probability vs posterior probability
- Bayes' theorem: $P(A_i | B) = \frac{P(A_i) \cdot P(B | A_i)}{∑(P(A_j) \cdot P(B | A_j))}$
### discrete probability measurement
  - expected value: $E[X] = ∑(x \cdot P(x))$
  - variance: $Var[X] = ∑((x - E[X])^2 \cdot P(x)) = E[X^2] - E[X]^2$
  - bernoulli distribution:
    - $q = 1 - p$
    - $E[X] = p$, $Var[X] = pq$
  - binomial probability distribution: ($0 ≤ i ≤ n$)
    - $P(i) = {{n}\choose{i}} \cdot p^i \cdot q^{n - i}$
    - $∑({{n}\choose{i}} * p^i * q^{n - i}) = 1$
    - $E[X] = np$, $Var[X] = npq$
  - hypergeometric distribution: ??
    - i: success times in sample
    - S: success times in population
    - n: sample size or experiment times
    - $P(i) = \cfrac{{{S}\choose{i}} \cdot {{N - S}\choose{n - x}}}{{N}\choose{n}}$
  - Poisson probability distribution ...
### continuous probability measurement
- continuous uniform distribution
    - $E[X] = \cfrac{x_{max} - x_{min}}{2}$
    - $Var[X] = \cfrac{(x_{max} - x_{min})^2}{12}$
- normal distribution ??
- standard normal distribution
  - $z = \cfrac{x - µ}{σ}$
  $$
  \begin{bmatrix}
  1 & 0.3413\\
  2 & 0.4772\\
  3 & 0.4897\\
  \end{bmatrix}
  $$
- exponential distribution ??
### sampling
- sampling methods:
  - simple sampling
  - systematic random sampling
  - stratified random sampling
  - cluster sampling
- sampling error: $\bar{x} - µ$
- central limit theorem:
  - the distributions of sample mean converge to normal distribution
- standard error of the sample mean: $σ_{\bar{x}} = \cfrac{σ}{\sqrt{n}}$

---
## estimation
point estimate

### confidence interval
- 95% confidence interval z score, -1.96 ≤ z ≤ 1.96
- 90% confidence interval z score, -1.65 ≤ z ≤ 1.65
- confidence interval for population:
    - for z test: $\bar{x} ± z \cdot \frac{σ}{\sqrt{n}}$
    - for t test: $\bar{x} ± t \cdot \frac{s}{\sqrt{n}}$
    - binary proportion: $p ± z \cdot \sqrt{\cfrac{p \cdot q}{n}}$
- finite-population correction factor... ??

### hypothesis test
- steps:
  1. construct hypothesis.
    - $H_0$: null hypothesis
    - $H_1$: alternate hypothesis
  2. choose level of significance. (.10, .05, .01, .001)
    - type I (α) error  (reject $H_0$ when it's actually true)
    - type II(ß) error (not reject $H_0$ when it's false)
  3. choose test statistics.
    - $z = \cfrac{\bar{x} - µ}{σ / \sqrt{n}}$
    - $t = \cfrac{\bar{x} - µ}{s / \sqrt{n}}$
  4. determine decision rule
    - critical value
    - two-tail
    - one-tail
  5. make decision (finding expected value from sample)
  6. conclusion
- suppose a population by a statistic.
    - $H_0$: µ = statistic
    - $H_1$: µ ≠ statistic
- suppose two independent population has or hasn't a association.
    - the selection that make up one sample does not influence the selection in the other sample.
    - $H_0: µ_1 ≤ µ_2 \space | \space µ_1 = µ_2$
    - $H_1: µ_1 > µ_2 \space | \space  µ_1 ≠ µ_2$
    - when σ is known
        - $σ^2_{\bar{x_1} - \bar{x_2}} = \frac{σ^2_1}{n_1} + \frac{σ^2_2}{n_2}$
        - $z = \cfrac{\bar{x_1} - \bar{x_2}}{σ^2_{\bar{x_1} - \bar{x_2}}}$
    - when σ is unknown
        - assume σ are same across different sample
            - $s^2_p = \cfrac{s^2_1 (n_1 - 1) + s^2_2 (n_2 - 1)}{n_1 + n_2 - 2}$
            - $t = \cfrac{\bar{x_1} - \bar{x_2}}{\sqrt{s^2_p (\frac{1}{n_1} + \frac{1}{n_2})}}$
        - σ may be different across different sample
            - t = (\bar{x_1} - \bar{x_2}) / \sqrt{s^2_1 / n_1 + s^2_2 / n_2}
            - df = ...
- suppose paired samples has or hasn't an association
    - the selection that make up one sample influence the selection in the other sample. (i.e. (pre, post))

    - $H_0: µ_d = 0$ (no difference between sample)
    - $H_1: µ_d ≠ 0$
    - $\bar{d} = \frac{∑(\bar{x_1} - \bar{x_2})}{n}$
    - $s_d = \frac{\sqrt{∑(d - \bar{d})^2}}{n - 1}$
    - $t = \frac{\bar{d}}{s_d / \sqrt{n}}$
### analysis of variance
- F-distribution: $F = \cfrac{s^2_1}{s^2_2}$, $∀ s_1 > s_2$
- ANOVA ???
    - $\bar{x}_g = \frac{∑x}{n}$ (grand mean)
    - $s = ∑(x - \bar{x}_g)^2$ (SS total)
    - $s_e = ∑(∑(x - \bar{x}_c)^2)$ (SSE(e for error) | SSW(w for within group))
    - $s_t = s - s_w$ (SST(t for treatment) | SSB(b for between groups))
    - $F = \frac{s_t / (n_t - 1)}{s_e / n}$
- confidence level for paired treatment difference ???
- SSB(b for blocking variable) ???
- two-factor experiment ??? interaction effect ??? interaction hypothesis test ???

### correlation, regression
- correlation
  - correlation coefficient (ρ for population, r for sample)
      - $r = \frac{∑(x - \bar{x})(y - \bar{y})}{(n - 1) \cdot s_x \cdot x_y}$
      - ∀ r, -1 ≤ r ≤ 1
  - spurious correlation
  - significance of correlation
      - $t = \cfrac{r \cdot \sqrt{n - 2}}{\sqrt{1 - r^2}}$
- regression
  - least squares principle, residual
  - $\hat{y} = a + bx$
    - $b = r(\frac{s_y}{s_x})$ ??
    - $a = \bar{y} - b\bar{x}$ ??
  - standard error of estimate: $s_{y \cdot x} = \sqrt{\cfrac{∑(y - \hat{y})^2}{n - 2}}$
  - 斜率test ???
  - R-square ???
    - $r^2 = \frac{SSR}{SS \space total} = 1 - \frac{SSE}{SS \space total}$
  - confidence interval vs predication interval ???
- multiple regression ??
  - forward selection, backward elimination
  - $\hat{y} = a + b_1x_1 + b_2x_2 + ... + b_kx_k$
  - $s_{y \cdot x_1 \cdot x_2 ...x_k} = \sqrt{\cfrac{∑(y - \hat{y})^2}{n - (k + 1)}} = \sqrt{\cfrac{SSE}{n - (k + 1)}}$
  - model: $Y = ß_1X_1 + ß_2X_2 + ß_3X_3 + ... + ß_kX_k$
  - global test ?? individual test ??
  - stepwise regression ?? best subset regression ??
  - homoscedasticity ??
  - variance inflation factor ??
- autocorrelation
### on nominal, ordinal variables
- binomial distribution:
  - one sample
    1. construct hypothesis
      - $H_0: π ≥ v$
      - $H_1: π < v$
    2. choose level of significance
      - 0.1 | 0.05 | 0.01 ...
    3. choose statistic
      - $z = \cfrac{p - π}{\sqrt{\frac{π (1 - π)}{n}}}$
    4. determine decision rule
      - critical value = zOf(0.5 - level of significance)
    5. make decision
      - p = 0.5 - areaOf(z)
      - p < critical value | p ≥ critical value
  - two sample
    1. construct hypothesis
      - $H_0: π_w = π_m$
      - $H_1: π_w ≠ π_m$
    2. choose level of significance (0.1 | 0.05 ,...)
    3. choose statistic (z)
      - $p_c = \cfrac{x_1 + x_2}{n_1 + n_2}$
      - $z = \cfrac{p_1 - p_2}{\sqrt{\frac{p_c(1 - p_c)}{n_1} + \frac{p_c(1 - p_c)}{n_2}}}$
    4. determine decision rule
      - one-tail or two-tail
      - find critical value from t table or z table
    5. make decision (get p, compare p with critical value)
    6. explain result (reject or not reject $H_0$)
- goodness-of-fit test ?? chi-square test ??
  - $\chi^2 = ∑\left[\cfrac{(f_o - f_e)^2}{f_e}\right]$ ??
  - same expectation
  - diff expectation
  - hypothize normal population
  - contigency table
- sign test ??
- median test ??
- wilcoxon ??
  - signed-rank test
  - rank-sum test
    - $z = \cfrac{W - \frac{n_1(n_1 + n_2 + 1)}{2}}{\sqrt{\frac{n_1n_2(n_1 + n_2 +1)}{12}}}$




# Takeaway
- distribution
  - for discrete variable
    - binomial distribution
    - hypergeometric distribution
    - poisson distribution
    - ...
  - for continuous variable
    - uniform distribution
    - normal distribution
    - exponential distribution
    - ...

