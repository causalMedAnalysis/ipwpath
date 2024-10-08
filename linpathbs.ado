*!TITLE: LINPATH - path-specific effects using linear models
*!AUTHOR: Geoffrey T. Wodtke, Department of Sociology, University of Chicago
*!
*! version 0.1 
*!

program define linpathbs, rclass
	
	version 15	

	syntax varlist(min=2 numeric) [if][in] [pweight], ///
		dvar(varname numeric) ///
		d(real) ///
		dstar(real) ///
		[cvars(varlist numeric)] ///
		[NOINTERaction] ///
		[cxd] ///
		[cxm] 
		
	qui {
		marksample touse
		count if `touse'
		if r(N) == 0 error 2000
		local N = r(N)
		}
			
	gettoken yvar mvars : varlist
	
	local num_mvars = wordcount("`mvars'")
	
	local i = 1
	foreach v of local mvars {
		local mvar`i' `v'
		local ++i
		}
	
	if (`num_mvars' == 1) {
	
		mlinpath `yvar' `mvars' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
	
		return scalar nde=r(nde)
		return scalar nie=r(nie)
		return scalar ate=r(ate)
	
		}

	if (`num_mvars' == 2) {
	
		mlinpath `yvar' `mvar1' `mvar2' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
	
		qui scalar mnde_M1M2=r(nde)

		mlinpath `yvar' `mvar1' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1=r(nde)
		
		return scalar pse_DY=mnde_M1M2
		return scalar pse_DM2Y=mnde_M1-mnde_M1M2
		return scalar pse_DM1Y=r(nie)
		return scalar ate=r(ate)
		
		}

	if (`num_mvars' == 3) {
	
		mlinpath `yvar' `mvar1' `mvar2' `mvar3' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
	
		qui scalar mnde_M1M2M3=r(nde)

		mlinpath `yvar' `mvar1' `mvar2' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1M2=r(nde)
		
		mlinpath `yvar' `mvar1' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1=r(nde)
		
		return scalar pse_DY=mnde_M1M2M3
		return scalar pse_DM3Y=mnde_M1M2-mnde_M1M2M3
		return scalar pse_DM2Y=mnde_M1-mnde_M1M2
		return scalar pse_DM1Y=r(nie)
		return scalar ate=r(ate)
		
		}

	if (`num_mvars' == 4) {
	
		mlinpath `yvar' `mvar1' `mvar2' `mvar3' `mvar4' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
	
		qui scalar mnde_M1M2M3M4=r(nde)

		mlinpath `yvar' `mvar1' `mvar2' `mvar3' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		scalar mnde_M1M2M3=r(nde)
		
		mlinpath `yvar' `mvar1' `mvar2' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1M2=r(nde)
		
		mlinpath `yvar' `mvar1' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1=r(nde)
		
		return scalar pse_DY=mnde_M1M2M3M4
		return scalar pse_DM4Y=mnde_M1M2M3-mnde_M1M2M3M4
		return scalar pse_DM3Y=mnde_M1M2-mnde_M1M2M3
		return scalar pse_DM2Y=mnde_M1-mnde_M1M2
		return scalar pse_DM1Y=r(nie)
		return scalar ate=r(ate)
		
		}
	
	if (`num_mvars' == 5) {

		mlinpath `yvar' `mvar1' `mvar2' `mvar3' `mvar4' `mvar5' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
	
		qui scalar mnde_M1M2M3M4M5=r(nde)

		mlinpath `yvar' `mvar1' `mvar2' `mvar3' `mvar4' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
	
		qui scalar mnde_M1M2M3M4=r(nde)

		mlinpath `yvar' `mvar1' `mvar2' `mvar3' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1M2M3=r(nde)
		
		mlinpath `yvar' `mvar1' `mvar2' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1M2=r(nde)
		
		mlinpath `yvar' `mvar1' [`weight' `exp'] if `touse', ///
			dvar(`dvar') cvars(`cvars')	d(`d') dstar(`dstar') ///
			`cxd' `cxm' `nointeraction'
		
		qui scalar mnde_M1=r(nde)
		
		return scalar pse_DY=mnde_M1M2M3M4M5
		return scalar pse_DM5Y=mnde_M1M2M3M4-mnde_M1M2M3M4M5
		return scalar pse_DM4Y=mnde_M1M2M3-mnde_M1M2M3M4
		return scalar pse_DM3Y=mnde_M1M2-mnde_M1M2M3
		return scalar pse_DM2Y=mnde_M1-mnde_M1M2
		return scalar pse_DM1Y=r(nie)
		return scalar ate=r(ate)
		
		}

end linpathbs
