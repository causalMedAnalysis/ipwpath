# ipwpath: A Stata Module for Analysis of Path-Specific Effects Using Inverse Probability Weighting

`ipwpath` is a Stata module designed to estimate path-specific effects using inverse probability weighting.

## Syntax

```stata
ipwpath depvar mvars, dvar(varname) d(real) dstar(real) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `mvars`: Specifies the mediators, arranged in causal order from the first to the last in the hypothesized causal sequence. 
- `dvar(varname)`: Specifies the treatment (exposure) variable. This variable must be binary (0/1).
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast of interest.

### Options

- `cvars(varlist)`: List of baseline covariates to include in the analysis. Categorical variables must be dummy coded.
- `sampwts(varname)`: Variable containing sampling weights to include in the analysis.
- `censor(numlist)`: Censors the inverse probability weights at the percentiles provided in `numlist`.
- `detail`: Prints the fitted models for the exposure used to construct the weights.
- `bootstrap_options`: All `bootstrap` options are available.

## Description

`ipwpath` uses inverse probability weighting to estimate path-specific effects through multiple mediators, and it computes inferential statistics using the nonparametric bootstrap. It constructs weights using logit models for the exposure, each conditioned on different combinations of mediators and the baseline confounders. This approach allows the isolation of effects that pass through specific causal pathways defined by the ordered mediators.

For example, with three causally ordered mediators (M1, M2, M3), it estimates:
- A model for the exposure with no mediators, just baseline confounders.
- A model for the exposure with M1 and baseline confounders.
- A model for the exposure with M1, M2, and baseline confounders.
- A model for the exposure with M1, M2, M3, and baseline confounders.

These models are used to construct a set of inverse probability weights, which then enable the calculation of direct and path-specific effects that operate through each mediator, net of the mediators that precede it causal order.

`ipwpath` allows sampling weights via the `sampwts` option, but it does not internally rescale them for use with the bootstrap. If using weights from a complex sample design that require rescaling to produce valid boostrap estimates, the user must be sure to appropriately specify the `strata`, `cluster`, and `size` options from the `bootstrap` command so that Nc-1 clusters are sampled within from each stratum, where Nc denotes the number of clusters per stratum. Failure to properly adjust the bootstrap sampling to account for a complex sample design that requires weighting could lead to invalid inferential statistics.

## Examples

```stata
// Load data
use nlsy79.dta

// Example with two causally ordered mediators
ipwpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) 

// Example with three causally ordered mediators and 1000 bootstrap replications
ipwpath std_cesd_age40 cesd_1992 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)

// Example with two causally ordered mediators, 1000 bootstrap replications, and weights censored at their 1st and 99th percentiles
ipwpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000) censor(1 99)
```

## Saved Results

`ipwpath` saves the following results in `e()`:

- **Matrices**:
  - `e(b)`: Matrix containing the total and path-specific effect estimates.

## Author

Geoffrey T. Wodtke  
Department of Sociology  
University of Chicago

Email: [wodtke@uchicago.edu](mailto:wodtke@uchicago.edu)

## References

- Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation.

## Also See

- Help: [logit R](#), [bootstrap R](#)
```
