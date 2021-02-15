clear

use "directory where data is located/data_v3.dta", clear


**BASELINES V1
set matsize 5000

drop if year > 2014
xtset regime_id year

*gwf - baseline - to get the gwf sample
logit F.gwf_fail v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   gwf_duration1 gwf_duration2 gwf_duration3 i.region2  i.year, cluster(country_id)
estimates store gwf
gen in_gwf = e(sample)

*vdh - baseline - to get the vdh sample
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year , cluster(country_id)
estimates store vdh
gen in_vdh = e(sample)

***LABELS
label variable v2x_polyarchy "Democracy"
label variable polyarchy_sq "Democracy$^2$"
label variable GDPgrowth  "Gdp growth"
label variable s_far_Maddison_gdppc_1990_estim  "L(Gdppc)"
label variable s_far_Maddison_pop_estimate  "L(population)"


**TABLE 3

*gwf - baseline
set more off
logit F.gwf_fail v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth  gwf_duration1 gwf_duration2 gwf_duration3 i.year  i.region2  if in_vdh==1 , cluster(country_id) 
estimates store m1

*vdh - baseline - same sample as GWF
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3  i.year i.region2  if in_gwf==1, cluster(country_id) 
estimates store m2

*vdh - baseline - full sample
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.year i.region2 , cluster(country_id) 
estimates store m3

*vdh - baseline - full sample - country-FE
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.country_id i.year, cluster(country_id) 
estimates store m4

estout  m1 m2 m3 m4  , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N ll r2)style (tex)

**TABLE 4 - different types of breakdown
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth  duration1 duration2 duration3 i.region2  i.year , cluster(country_id) 
estimates store m5

logit F.uprising v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2  i.year, cluster(country_id) 
estimates store m6

logit F.warint v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2  i.year, cluster(country_id) 
estimates store m7

logit F.reglib v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2  i.year, cluster(country_id) 
estimates store m8

estout  m5 m6 m7 m8  , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N ll r2)style (tex)


**TABLE 5 - BEFORE AND AFTER THE DIFFERENT CHANGEPOINTS

*high frequency period
gen highfreq = .
replace highfreq = 0
replace highfreq = 1 if (year>1798 & year<1881) | (year>1913&year<1995)

set more off
*1798-1881
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year  if year>1798 & year<1881 , cluster(country_id) 
estimates store m9
estat ic

*1881-1913
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year>1881 & year<1913 , cluster(country_id) 
estimates store m10
estat ic

*1913-1995
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year>1913 & year<1995 , cluster(country_id) 
estimates store m11
estat ic

*1995-2016
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year>1995 , cluster(country_id) 
estimates store m12
estat ic

**HIGH VS: LOW FREQUENCY PERIODS

logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if highfreq==1 , cluster(country_id) 
estimates store m13
estat ic

logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if highfreq==0 , cluster(country_id) 
estimates store m14
estat ic 

estout  m9 m10 m11 m12 m13 m14 , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N aic ll)style (tex)


**TABLE A7

**Pre-post changepoints for coups

*COUPS
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year , cluster(country_id) 
estimates store m14
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year<1960 , cluster(country_id) 
estimates store m15
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year>1960 & year <1981 , cluster(country_id) 
estimates store m16
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year>1981  , cluster(country_id) 
estimates store m17
estout m14 m15 m16 m17 , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N aic ll)style (tex)

**TABLE A8
**Pre-post changepoints for coups
*UPRISINGS
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year , cluster(country_id) 
estimates store m18
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year<1848 , cluster(country_id) 
estimates store m19
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year<1917 & year>1848 , cluster(country_id) 
estimates store m20
logit F.coup v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.region2 i.year if year>1917 , cluster(country_id) 
estimates store m21

estout m18 m19 m20 m21 , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N aic ll)style (tex)


*TABLE A9
* Subsamples for democracies and dictatorships

***********DIFFERENTIATING DEMOCRACIES AND DICTATORSHIPS
*merging in regimes data
drop _merge
merge m:1 country_id year using "directory where data is located\data_row.dta"


**BASELINES V1
set matsize 5000
sort regime_id year
drop if regime_id==.
sort regime_id year
duplicates list regime_id year, 

xtset regime_id year


*vdh - baseline - full sample - democracies
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.year i.region2 if v2x_regime>1, cluster(country_id) 
estimates store m1

*vdh - baseline - full sample - democracies - country-FE
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.country_id  if v2x_regime>1, cluster(country_id) 
estimates store m2

*vdh - baseline - full sample - dictatorships
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.year i.region2 if v2x_regime<2, cluster(country_id) 
estimates store m3

*vdh - baseline - full sample - dictatorships - country-FE
logit F.regchange v2x_polyarchy polyarchy_sq s_far_Maddison_gdppc_1990_estim  s_far_Maddison_pop_estimate GDPgrowth   duration1 duration2 duration3 i.country_id i.year if v2x_regime<2, cluster(country_id) 
estimates store m4

estout  m1 m2 m3 m4  , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N ll r2)style (tex)


**TABLE A10: ALTERNATIVE GDP MEASURE
clear
use "directory where data is located\data_v3.dta", clear

drop if year > 2014

merge m:1 country_id year using "directory where data is located\Data\alt_gdp2.dta"

set matsize 5000
sort regime_id year
drop if regime_id==.
sort regime_id year
duplicates list regime_id year, 

xtset regime_id year


*CREATE ALTERNATIVE GDP MEASURE
sort regime_id year
xtset regime_id year

gen e_migdppcln = log(e_migdppc)

by regime_id, sort : ipolate e_migdppcln year, generate(e_migdppclni)
sort regime_id year
by regime_id, sort : generate e_migdpgroi = 100*(exp(e_migdppclni) - exp(L.e_migdppclni))/exp(L.e_migdppclni)
summarize e_migdpgroi e_migdpgro, detail
sort regime_id year
gen lnpop = log(e_population)
by regime_id, sort : ipolate lnpop year, generate(lnpopi)

*gwf - baseline - for samme sample
logit F.gwf_fail v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi  gwf_duration1 gwf_duration2 gwf_duration3 i.region2  i.year, cluster(country_id)
estimates store gwf
gen in_gwf = e(sample)

*vdh - baseline - for samme sample
logit F.regchange v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi  duration1 duration2 duration3 i.region2 i.year , cluster(country_id)
estimates store vdh
gen in_vdh = e(sample)

***LABELS
label variable v2x_polyarchy "Democracy"
label variable polyarchy_sq "Democracy$^2$"
label variable e_migdpgroi  "Gdp growth"
label variable e_migdppclni  "L(Gdppc)"
label variable lnpopi  "L(population)"


*gwf - baseline
set more off
logit F.gwf_fail v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi  gwf_duration1 gwf_duration2 gwf_duration3 i.year  i.region2  if in_vdh==1 , cluster(country_id) 
estimates store m1

*vdh - baseline - same sample
logit F.regchange v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi   duration1 duration2 duration3  i.year i.region2  if in_gwf==1, cluster(country_id) 
estimates store m2

*vdh - baseline - full sample
logit F.regchange v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi  duration1 duration2 duration3 i.year i.region2 , cluster(country_id) 
estimates store m3

*vdh - baseline - full sample - interpolated - country-FE
logit F.regchange v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi   duration1 duration2 duration3 i.country_id i.year, cluster(country_id) 
estimates store m4

estout  m1 m2 m3 m4  , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N ll r2)style (tex)

*TABLE A11:

***Disaggregation

logit F.coup v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi  duration1 duration2 duration3 i.region2  i.year , cluster(country_id) 
estimates store m5

logit F.uprising v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi    duration1 duration2 duration3 i.region2  i.year, cluster(country_id) 
estimates store m6

logit F.warint v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi    duration1 duration2 duration3 i.region2  i.year, cluster(country_id) 
estimates store m7

logit F.reglib v2x_polyarchy polyarchy_sq e_migdppclni e_migdpgroi lnpopi    duration1 duration2 duration3 i.region2  i.year, cluster(country_id) 
estimates store m8

estout  m5 m6 m7 m8  , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) label starlevels (* 0.05 ** 0.01 *** 0.001) stats (N ll r2)style (tex)


