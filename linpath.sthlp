{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for linpath}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:linpath} {hline 2}} analysis of path-specific effects using linear models {p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:linpath} {depvar} {help indepvars:mvars} {ifin} [{it:{help weight:pweight}}] {cmd:,} 
{opt dvar(varname)} 
{opt d(real)} 
{opt dstar(real)} 
{opt cvars(varlist)} 
{opt nointer:action} 
{opt cxd} 
{opt cxm} 
{opt detail}
[{it:{help bootstrap##options:bootstrap_options}}]

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt mvars} - this specifies the mediators in causal order, beggining with the first in the hypothesized causal sequence
and ending with the last. Up to 5 causally ordered mediators are permitted.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable.

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt nointer:action} - this option specifies whether treatment-mediator interactions are not to be
included in the outcome models (the default assumes interactions are present).

{phang}{opt cxd} - this option specifies that all two-way interactions between the treatment and baseline covariates are
included in the mediator and outcome models.

{phang}{opt cxm} - this option specifies that all two-way interactions between the mediators and baseline covariates are
included in the outcome models.

{phang}{opt detail} - this option prints the fitted models for the mediators and outcome used to construct effect estimates.

{phang}{it:{help bootstrap##options:bootstrap_options}} - all {help bootstrap} options are available. {p_end}

{title:Description}

{pstd}{cmd:linpath} estimates path-specific effects using linear models, and it computes inferential statistics using the nonparametric bootstrap.

{pstd}With K causally ordered mediators, this approach is implemented as follows: 

{pstd}1. Fit models for the mediators and outcome. For k = 1, 2, . . . ,K:

{pstd}(a) Fit a linear model for the kth mediator conditional on the exposure and baseline confounders.

{pstd}(b) Fit a linear model for the outcome conditional on the exposure, baseline confounders, and all
the mediators in Mk={M1,...,Mk}.

{pstd}2. Calculate estimates for the path-specific effects using coefficients from the models fit in step 1.

{pstd}If there are K causally ordered mediators, {cmd:linpath} provides estimates for the total effect and then for K+1 path-specific effects:
the direct effect of the exposure on the outcome that does not operate through any of the mediators, and then a separate path-specific effect 
operating through each of the K mediators, net of the mediators that precede it in causal order. If only a single mediator is specified, 
{cmd:linpath} just reports estimates of conventional natural direct and indirect effects through a univariate mediator. {p_end}

{pstd}If using {help pweights} from a complex sample design that require rescaling to produce valid boostrap estimates, be sure to appropriately 
specify the strata(), cluster(), and size() options from the {help bootstrap} command so that Nc-1 clusters are sampled from each stratum 
with replacement, where Nc denotes the number of clusters per stratum. Failing to properly adjust the bootstrap procedure to account
for a complex sample design and its associated sampling weights could lead to invalid inferential statistics. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

{pstd} percentile bootstrap CIs with default settings and K=2 causally ordered mediators: {p_end}
 
{phang2}{cmd:. linpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0)} {p_end}

{pstd} percentile bootstrap CIs with 1000 replications and K=3 causally ordered mediators: {p_end}
 
{phang2}{cmd:. linpath std_cesd_age40 cesd_1992 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)} {p_end}

{pstd} percentile bootstrap CIs with default settings, K=2 causally ordered mediators, and all two-way interactions: {p_end}
 
{phang2}{cmd:. linpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) cxd cxm} {p_end}

{pstd} percentile bootstrap CIs with default settings, K=2 causally ordered mediators, and no interactions, printing detailed output: {p_end}
 
{phang2}{cmd:. linpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) nointer reps detail} {p_end}

{title:Saved results}

{pstd}{cmd:linpath} saves the following results in {cmd:e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}matrix containing the total and path-specific effect estimates{p_end}

{title:Author}

{pstd}Geoffrey T. Wodtke {break}
Department of Sociology{break}
University of Chicago{p_end}

{phang}Email: wodtke@uchicago.edu

{title:References}

{pstd}Wodtke, GT and X Zhou. Causal Mediation Analysis. In preparation. {p_end}

{title:Also see}

{psee}
Help: {manhelp regress R}, {manhelp bootstrap R}
{p_end}
