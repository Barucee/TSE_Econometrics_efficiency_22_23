* Load of the file

import excel "C:/Users/bruce/OneDrive/Documents/Github/Data/Econometrics_efficiency_TSE_22_23/electricity_project_dataset.xlsx", sheet("Sheet1") firstrow clear


* Filter the data for keeping only the last year

keep if year == 6


* Rename the column

rename firm dmu

gen ly=log(y)
gen llab=log(lab)
gen lk=log(k)
gen lfuel=log(fuel)

frontier ly llab lk lfuel

predict ef_cs7, te

*Frontier analysis and test for Cobb Douglas specification
frontier ly llab lk lfuel
test _b[llab] + _b[lk] + _b[lfuel] = 1

*Obtaining efficiency scores and their means
predict ef_cs8, te
mean ef_cs8

*Graph
twoway scatter ef_cs8 dmu

quantile ef_cs8

*Parameterization of mu as a function of the controls

frontier ly llab lk lfuel, vhet(lk)
frontier ly llab lk lfuel, vhet(lfuel)
frontier ly llab lk lfuel, vhet(llab)
frontier ly llab lk lfuel, vhet(lk lfuel)
frontier ly llab lk lfuel, vhet(lk llab)
frontier ly llab lk lfuel, vhet(lfuel llab)
frontier ly llab lk lfuel, vhet(lfuel llab lk)

*Parameterization of u as a function of the controls

frontier ly llab lk lfuel, uhet(lk)
frontier ly llab lk lfuel, uhet(lfuel)
frontier ly llab lk lfuel, uhet(llab)
frontier ly llab lk lfuel, uhet(lk lfuel)
frontier ly llab lk lfuel, uhet(lk llab)
frontier ly llab lk lfuel, uhet(lfuel llab)
frontier ly llab lk lfuel, uhet(lfuel llab lk)

*Quantile analysis after taking into account heteroskedasticity
frontier ly llab lk lfuel, vhet(lfuel)

predict ef_cs9,te
quantile ef_cs9

*Using other distributions for the inefficiency term
	*Exp
frontier ly llab lk lfuel, distribution(exponential) vhet(lfuel)

predict ef_cs10, te

	*Truncated normal
frontier ly llab lk lfuel, distribution(tnormal)

predict ef_cs11, te





import excel "C:/Users/bruce/OneDrive/Documents/Github/Data/Econometrics_efficiency_TSE_22_23/electricity_project_dataset.xlsx" sheet("Sheet1") firstrow clear
xtset firm year

*Fixing the half normal distribution
constraint 1 [mu]_cons==0

*Generating log variables
gen ly=log(y)
gen llab=log(lab)
gen lk=log(k)
gen lfuel=log(fuel)


*First model, time invariant
xtfrontier  ly llab lk lfuel, ti constraint(1)
estimates store est1
predict ef_panti,te
quantile ef_panti

*Second model, time varying effects
xtfrontier  ly llab lk lfuel, tvd constraint(1)
estimates store est2
predict ef_panti2, te
tab firm year, summarize(ef_panti2)
* Does not function : esttab est1 est2 using est.tex


