# ipwpath: Estimates Path-Specific Effects Using Inverse Probability Weighting

`ipwpath` is a Stata module designed to estimate path-specific effects using inverse probability weighting, ideal for analyzing causal effects mediated through multiple, causally ordered mediators.

## Syntax

```stata
ipwpath depvar mvars, dvar(varname) d(real) dstar(real) [options]
```

### Required Arguments

- `depvar`: Specifies the outcome variable.
- `mvars`: Specifies the mediators, arranged in causal order from the first to the last in the hypothesized causal sequence. Up to 5 causally ordered mediators are permitted.
- `dvar(varname)`: Specifies the treatment (exposure) variable. This variable must be binary (0/1).
- `d(real)`: Reference level of treatment.
- `dstar(real)`: Alternative level of treatment, defining the treatment contrast of interest.

### Options

- `cvars(varlist)`: List of baseline covariates to include in the analysis. Categorical variables must be dummy coded.
- `sampwts(varname)`: Variable containing sampling weights to include in the analysis.
- `reps(integer)`: Number of replications for bootstrap resampling (default is 200).
- `strata(varname)`: Variable identifying resampling strata.
- `cluster(varname)`: Variable identifying resampling clusters.
- `level(cilevel)`: Confidence level for constructing bootstrap confidence intervals (default is 95%).
- `seed(passthru)`: Seed for replicable bootstrap resampling.
- `detail`: Prints the fitted models for the exposure used to construct the weights.

## Description

`ipwpath` uses inverse probability weighting to estimate path-specific effects across multiple mediators. It constructs weights using up to K+1 logit models, each conditioned on different combinations of mediators and baseline confounders. This approach allows the isolation of effects that pass through specific causal pathways defined by the ordered mediators.

For example, with three causally ordered mediators (M1, M2, M3), it estimates:
- A model with no mediators, just baseline confounders.
- A model with M1 and baseline confounders.
- A model with M1, M2, and baseline confounders.
- A model with M1, M2, M3, and baseline confounders.

These models enable the calculation of direct effects and path-specific indirect effects that operate through each mediator, net of the mediators that precede it.

## Examples

```stata
// Load data
use nlsy79.dta

// Example with two causally ordered mediators
ipwpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)

// Example with three causally ordered mediators
ipwpath std_cesd_age40 cesd_1992 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)
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
