{smcl}
{* *! version 0.1, 1 July 2024}{...}
{cmd:help for ipwpath}{right:Geoffrey T. Wodtke}
{hline}

{title:Title}

{p2colset 5 18 18 2}{...}
{p2col : {cmd:ipwpath} {hline 2}} estimates path-specific effects using inverse probability weighting {p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 18 2}
{cmd:ipwpath} {depvar} {help indepvars:mvars} {ifin}{cmd:,} dvar({varname}) mvar({varname}) 
d({it:real}) dstar({it:real}) m({it:real}) [cvars({varlist})
{reps({it:integer}) strata({varname}) cluster({varname}) level(cilevel) seed({it:passthru}) sampwts({varname}) detail]

{phang}{opt depvar} - this specifies the outcome variable.

{phang}{opt mvars} - this specifies the mediators in causal order, beggining with the first in the hypothesized causal sequence
and ending with the last. Up to 5 causally ordered mediators are permitted.

{phang}{opt dvar(varname)} - this specifies the treatment (exposure) variable. This variable must be binary (0/1).

{phang}{opt d(real)} - this specifies the reference level of treatment.

{phang}{opt dstar(real)} - this specifies the alternative level of treatment. Together, (d - dstar) defines
the treatment contrast of interest.

{title:Options}

{phang}{opt cvars(varlist)} - this option specifies the list of baseline covariates to be included in the analysis. Categorical 
variables need to be coded as a series of dummy variables before being entered as covariates.

{phang}{opt sampwts(varname)} - this option specifies a variable containing sampling weights to include in the analysis.

{phang}{opt reps(integer)} - this option specifies the number of replications for bootstrap resampling (the default is 200).

{phang}{opt strata(varname)} - this option specifies a variable that identifies resampling strata. If this option is specified, 
then bootstrap samples are taken independently within each stratum.

{phang}{opt cluster(varname)} - this option specifies a variable that identifies resampling clusters. If this option is specified,
then the sample drawn during each replication is a bootstrap sample of clusters.

{phang}{opt level(cilevel)} - this option specifies the confidence level for constructing bootstrap confidence intervals. If this 
option is omitted, then the default level of 95% is used.

{phang}{opt seed(passthru)} - this option specifies the seed for bootstrap resampling. If this option is omitted, then a random 
seed is used and the results cannot be replicated. {p_end}

{phang}{opt detail} - this option prints the fitted models for the exposure used to construct the weights. {p_end}

{title:Description}

{pstd}{cmd:ipwpath} estimates path-specific effects using inverse probability weighting. If there are K causally ordered mediators, 
then K+1 logit models for the exposure, conditional on the baseline confounders and different sets of mediators, are estimated 
to construct the weights. For example, with K=3 causally ordered mediators, denoted by M1, M2, and M3, respectively, four different models 
are estimated: a logit model for the exposure conditional on the baseline confounders only (if specified); a logit model for the exposure
conditional on M1 and the baseline confounders; a logit model for the exposure conditional on M1, M2, and the baseline confounders; and lastly,
a logit model for the exposure conditional on M1, M2, M3, and the baseline confounders. Collectively, these models are used to construct
the different inverse probability weights needed to construct path-specific effects through the three different mediators. 

{pstd}If there are K causally ordered mediators, {cmd:ipwpath} provides estimates for the total effect and then for K+1 path-specific effects:
the direct effect of the exposure on the outcome that does not operate through any of the mediators, and then a separate path-specific effect 
operating through each of the K mediators, net of the mediators that precede it in causal order. If only a single mediator is specified, 
{cmd:ipwpath} reverts to estimates of conventional natural direct and indirect effects through a univariate mediator. {p_end}

{title:Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. use nlsy79.dta} {p_end}

 
{pstd} percentile bootstrap CIs with default settings and K=2 causally ordered mediators: {p_end}
 
{phang2}{cmd:. ipwpath std_cesd_age40 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)} {p_end}

{pstd} percentile bootstrap CIs with default settings and K=3 causally ordered mediators: {p_end}
 
{phang2}{cmd:. ipwpath std_cesd_age40 cesd_1992 ever_unemp_age3539 log_faminc_adj_age3539, dvar(att22) cvars(female black hispan paredu parprof parinc_prank famsize afqt3) d(1) dstar(0) reps(1000)} {p_end}
{title:Saved results}

{pstd}{cmd:ipwpath} saves the following results in {cmd:e()}:

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
Help: {manhelp logit R}, {manhelp bootstrap R}
{p_end}
