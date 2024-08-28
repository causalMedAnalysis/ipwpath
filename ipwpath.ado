*!TITLE: IPWPATH - analysis of path-specific effects using inverse probability weighting
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!


program define ipwpath, eclass

	version 15	

	syntax varlist(min=2 numeric) [if][in], ///
		dvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		[cvars(varlist numeric)] ///
		[sampwts(varname numeric)] ///
		[reps(integer 200)] ///
		[strata(varname numeric)] ///
		[cluster(varname numeric)] ///
		[level(cilevel)] ///
		[seed(passthru)] ///
		[saving(string)] ///
		[detail]
		
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
	}
	
	gettoken yvar mvars : varlist
	
	local num_mvars = wordcount("`mvars'")

	if (`num_mvars' > 5) {
		display as error "ipwpath only supports a maximum of 5 mvars"
		error 198
	}
	
	local i = 1
	foreach v of local mvars {
		local mvar`i' `v'
		local ++i
	}

	foreach i in `dvar' {
		confirm variable `i'
		qui levelsof `i', local(levels)
		if "`levels'" != "0 1" & "`levels'" != "1 0" {
			display as error "The variable `i' is not binary and coded 0/1"
			error 198
		}
	}
	
	if ("`sampwts'" == "") {
		tempvar sampwts
		qui gen `sampwts' = 1 if `touse'
		}
		
	/***COMPUTE POINT AND INTERVAL ESTIMATES***/
	if (`num_mvars' == 1) {
	
		if ("`detail'" != "") {
			logit `dvar' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `cvars' [pw=`sampwts'] if `touse'
		}

		if ("`saving'" != "") {
			bootstrap ///
				ATE=r(ate) ///
				NDE=r(nde) ///
				NIE=r(nie), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					saving(`saving', replace) ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	
		if ("`saving'" == "") {
			bootstrap ///
				ATE=r(ate) ///
				NDE=r(nde) ///
				NIE=r(nie), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	}
		
	if (`num_mvars' == 2) {

		if ("`detail'" != "") {
			logit `dvar' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `cvars' [pw=`sampwts'] if `touse'
		}
		
		if ("`saving'" != "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					saving(`saving', replace) ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	
		if ("`saving'" == "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	}

	if (`num_mvars' == 3) {

		if ("`detail'" != "") {
			logit `dvar' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `mvar3' `cvars' [pw=`sampwts'] if `touse'
		}
		
		if ("`saving'" != "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM3Y=r(pse_DM3Y) ///				
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					saving(`saving', replace) ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	
		if ("`saving'" == "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM3Y=r(pse_DM3Y) ///				
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	}

	if (`num_mvars' == 4) {

		if ("`detail'" != "") {
			logit `dvar' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `mvar3' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `mvar3' `mvar4' `cvars' [pw=`sampwts'] if `touse'
		}
		
		if ("`saving'" != "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM4Y=r(pse_DM4Y) ///				
				PSE_DM3Y=r(pse_DM3Y) ///
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					saving(`saving', replace) ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	
		if ("`saving'" == "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM4Y=r(pse_DM4Y) ///								
				PSE_DM3Y=r(pse_DM3Y) ///				
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	}

	if (`num_mvars' == 5) {

		if ("`detail'" != "") {
			logit `dvar' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `mvar3' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `mvar3' `mvar4' `cvars' [pw=`sampwts'] if `touse'
			logit `dvar' `mvar1' `mvar2' `mvar3' `mvar4' `mvar5' `cvars' [pw=`sampwts'] if `touse'
		}
		
		if ("`saving'" != "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM5Y=r(pse_DM5Y) ///				
				PSE_DM4Y=r(pse_DM4Y) ///				
				PSE_DM3Y=r(pse_DM3Y) ///
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					saving(`saving', replace) ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	
		if ("`saving'" == "") {
			bootstrap ///
				ATE=r(ate) ///
				PSE_DY=r(pse_DY) ///
				PSE_DM5Y=r(pse_DM5Y) ///		
				PSE_DM4Y=r(pse_DM4Y) ///								
				PSE_DM3Y=r(pse_DM3Y) ///				
				PSE_DM2Y=r(pse_DM2Y) ///
				PSE_DM1Y=r(pse_DM1Y), ///
					reps(`reps') strata(`strata') cluster(`cluster') level(`level') `seed' ///
					noheader notable: ipwpathbs `yvar' `mvars' if `touse', ///
					dvar(`dvar') cvars(`cvars') d(`d') dstar(`dstar') sampwts(`sampwts')
		}
	}
	
	estat bootstrap, p noheader
	
end ipwpath
