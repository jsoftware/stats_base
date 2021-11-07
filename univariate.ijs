NB. stats/base/univariate
NB. Univariate statistics

NB.*mean v         arithmetic mean (dyadic: weighted)
NB.*geomean v      geometric mean
NB.*harmean v      harmonic mean
NB.*commonmean v   common mean
NB.
NB.*dev v          deviation from mean (dyadic: weighted)
NB.*ssdev v        sum of squared deviations (dyadic: weighted)
NB.*var v          sample variance (dyadic: weighted)
NB.*stddev v       standard deviation (dyadic: weighted)
NB.*varp v         population variance
NB.*stddevp v      population standard deviation
NB.*skewness v     skewness
NB.*kurtosis v     kurtosis
NB.
NB.*min v          minimum
NB.*max v          maximum
NB.*midpt v        index of midpoint
NB.*median v       median
NB.
NB. cile v         x cile values of y
NB. dstat v        descriptive statistics
NB. freqcount v    frequency count
NB. histogram v    histogram
NB. binnedData a   applies u to binned data y as specified by intervals x

cocurrent 'z'

mean=: (+/ % #) : wmean        NB. arithmetic mean (dyadic: weighted)
geomean=: mean &.: ^.          NB. geometric mean
harmean=: mean &.: %           NB. harmonic mean
commonmean=: [: {. (%:@*/ , -:@+/) ^: _

wmean=: +/@[ %~ +/@:*          NB. weighted arithmetic mean
wdev=: ] -"_1 _ wmean          NB. weighted deviation from mean
wssdev=: [ +/@:* *:@wdev       NB. weighted sum of squared deviations
wvar=: (#@-.&0 %~ <:@#@-.&0 * +/)@[ %~ wssdev  NB. weighted sample variance
wstddev=: %:@wvar              NB. weighted sample standard deviation

dev=: (-"_1 _ mean) : wdev     NB. deviation from mean (dyadic: weighted)
ssdev=: (+/@:*:@dev) : wssdev  NB. sum of squared deviations (dyadic: weighted)
var=: (ssdev % <:@#) : wvar    NB. sample variance (dyadic: weighted)
stddev=: (%:@var) : wstddev    NB. sample standard deviation (dyadic: weighted)

NB. "p" suffix = population definitions
varp=: ssdev % #               NB. population variance
stddevp=: %: @ varp            NB. population standard deviation

min=: <./
max=: >./
midpt=: -:@<:@#
median=: -:@(+/)@((<. , >.)@midpt { /:~)
midpts=: midpt : ((%~ i.&.<:)@[ * <:@#@])

NB.*interpolate v  simple linear interpolation for intermediate points
NB.y is: X,:Y  lists of X and corresponding Y values
NB.x is: XI    list of points XI to interpolate Y for to return YI
NB.EG: (1.1 * i.8) interpolate (i.10) ,: (1.1 ^~ i.10)
NB. developed from http://www.jsoftware.com/pipermail/programming/2021-May/058117.html
NB. issues with floating point accuracy?
interpolate_fjrgs =: 4 : 0
  ai =. (<:{:$y) <. (0{y) I. x
  p =. (x - (0{y){~ <:ai) % -/"1 (0{y) {~ (,. <:) ai
  ((,. -.)p) +/@:*"1 (1{y) {~ (,. <:) ai
)
Note 'issues with floating point accuracy in interpolate_fjrgs ?'
  require 'numeric'
  T=: 3 4 5 6 7 3 4 9 3 2 4 2
  T_xtiles_res=: 1 1 2 2 2 3 3 3 3 3 4 4 4 4
  (/:~ T,9 9) Idotr~ (>:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9
  assert T_xtiles_res -: (/:~ T,9 9) Idotr~ (>:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9
  (>:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9
  ((>:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9) - 2 3 4 6.75 10
  (1e_10 round (>:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9) - 2 3 4 6.75 10
  (/:~ T,9 9) Idotr~ (1e_10 round >:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9
  assert T_xtiles_res -: (/:~ T,9 9) Idotr~ (1e_10 round >:@(>./) ,~ }:) 4 nquantiles /:~ T,9 9
)

NB. http://www.jsoftware.com/pipermail/programming/2008-June/011078.html
NB. https://code.jsoftware.com/wiki/Phrases/Arith#Interpolation
interpolate =: 4 : 0
ix =. 1 >. (<:{:$y) <. (0{y) I. x
intpoly =. (1 { y) ,. (,~ {.)   %~/ 2 -/\"1 y
(ix { intpoly) p. ((<0;ix) { y) -~ x
)

NB.*qpts v  calculates points for quantile computation
NB. ((k-1)/(n-1) ,: v[k]), for k = 1:n where n = length(v)
NB. corresponds to Definition 7 of Hyndman and Fan (1996),
NB. (same as the R, NumPy & Julia default)
NB.EG: qpts 3 2 4 2 4 2 8 4 5 9 3 2
qpts=: (i.@# % <:@#) ,: /:~

NB.*quantiles v  returns the value which partitions y into x subsets of nearly equal size
NB. y is:
NB. EG: 0.25 0.5 0.75 quantiles 2 4 5 6 7 8 9
quantiles=: 0 0.25 0.5 0.75 1&$: : (interpolate qpts)

NB.*nquantiles v  returns the values which partition y into x subsets of nearly equal size
NB. returns 1 less value than the number of subsets
NB. EG: 4 nquantiles 2 4 5 6 7 8 9
nquantiles=: 4&$: : ((i.@>: * %)@[ quantiles ])

NB.*xtiles v  m
xtiles=: ] Idotr~ [: (>:@(>./) ,~ }:) nquantiles

NB.*rankOrdinal a  ordinal ranking ("0 1 2 3") of array y
NB. tied items are ranked on the order they appear in y
NB. eg: /: rankOrdinal 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankOrdinal 5 2 5 0 6 2 4  NB. rank descending
rankOrdinal=: 1 :'/:@u'

NB.*rankCompete a  standard competition ranking ("0 0 2 3") of array y
NB. eg: /: rankCompete 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankCompete 5 2 5 0 6 2 4  NB. rank descending
rankCompete=: 1 :'u~ i. ]'

NB.*rankDense a  dense ranking ("0 0 1 2") of array y
NB. eg: /: rankDense 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankDense 5 2 5 0 6 2 4  NB. rank descending
rankDense=: 1 :'u rankOrdinal@~. {~ ~. i. ]'

NB.*rankFractional a  fractional ranking ("0 1.5 1.5 3") of array y
NB. Items with the same ranking have the mean of their ordinal ranks.
NB. eg: /: rankFractional 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankFractional 5 2 5 0 6 2 4  NB. rank descending
rankFractional=: 1 : '(] (+/ % #)/. u rankOrdinal) {~ ~. i. ]'

NB. =========================================================
NB.*cile v  assign values of y to x subsets of nearly equal size
NB. eg: 3 cile i.12
cile=: $@] $ ((* <.@:% #@]) /:@/:@,)

NB. =========================================================
NB.*dstat v  descriptive statistics
NB. table of formatted descriptive statistics
dstat=: 3 : 0
t=. '/sample size/minimum/maximum/median/mean'
t=. t,'/std devn/skewness/kurtosis'
t=. ,&':  ' ;._1 t
v=. $,min,max,median,mean,stddev,skewness,kurtosis
t,. ": ,. v y
)

NB. =========================================================
NB.*freqcount v  frequency count
NB. (value, frequency) sorted by decreasing frequency
freqcount=: (\: {:"1)@(~. ,. #/.~)

NB.*Idotr v  Equivalent to I. but intervals are closed on the left and open on the right
NB. Idotr : (0{x) <= y < (1{x)
NB.    I. : (0{x) < y <= (1{x)
Idotr=: |.@[ (#@[ - I.) ]

NB.*histogram v  tally of the items in each bin
NB. x is a list of interval start/end points. The number of intervals is 1+#x
NB. y is an array of data
histogramR=: <: @ (#/.~) @ (i.@>:@#@[ , I.)      NB. Intervals (,]
histogramL=: <: @ (#/.~) @ (i.@>:@#@[ , Idotr)   NB. Intervals [,)
histogram=: histogramL f.

NB. =========================================================
NB.*binnedData a  Applies verb u to the values of y after binning them in the intervals specified by x
NB. x is a list of interval start/end points. The number of intervals is 1+#x
NB. y is an array of data.
NB. eg: < binnedData  NB. verb to box the binned data
NB. eg: (+/ % #) binnedData  NB. verb to average the binned data
binnedData=: adverb define
  bidx=. i.@>:@# x                    NB. indicies of bins
  x (Idotr (u@}./.)&(bidx&,) ]) y     NB. apply u to data in bins after dropping first value
)

NB. =========================================================
NB.*kurtosis v  4th moment coefficient
kurtosis=: # * +/@(^&4)@dev % *:@ssdev

NB. =========================================================
NB.*skewness v  3rd moment coefficient
skewness=: %:@# * +/@(^&3)@dev % ^&1.5@ssdev
