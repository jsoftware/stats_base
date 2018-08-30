NB. stats/base/univariate
NB. Univariate statistics

NB.*mean v         arithmetic mean
NB.*geomean v      geometric mean
NB.*harmean v      harmonic mean
NB.*commonmean v   common mean
NB.
NB.*dev v          deviation from mean
NB.*ssdev v        sum of squared deviations
NB.*var v          sample variance
NB.*stddev v       standard deviation
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

cocurrent 'z'

mean=: +/ % #                   NB. arithmetic mean
geomean=: */ %:~ #              NB. geometric mean
harmean=: mean &.: %            NB. harmonic mean
commonmean=: [: {. (%:@*/ , -:@+/) ^: _

dev=: -"_1 _ mean         NB. deviation from mean
ssdev=: +/ @: *: @ dev    NB. sum of squared deviations
var=: ssdev % <:@#        NB. sample variance
stddev=: %: @ var         NB. sample standard deviation

NB. "p" suffix = population definitions
varp=: ssdev % #         NB. population variance
stddevp=: %: @ varp      NB. population standard deviation

min=: <./
max=: >./
midpt=: -:@<:@#
median=: -:@(+/)@((<. , >.)@midpt { /:~)

NB.*rankOrdinal a return the ordinal ranking ("0123") of array y
NB. tied items are ranked on the order they appear in y
NB. eg: /: rankOrdinal 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankOrdinal 5 2 5 0 6 2 4  NB. rank descending
rankOrdinal=: 1 :'/:@u'

NB.*rankCompete a return the standard competition ranking ("0013") of array y
NB. eg: /: rankCompete 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankCompete 5 2 5 0 6 2 4  NB. rank descending
rankCompete=: 1 :'u~ i. ]'

NB.*rankDense a return the dense ranking ("0012") of array y
NB. eg: /: rankDense 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankDense 5 2 5 0 6 2 4  NB. rank descending
rankDense=: 1 :'u rankOrdinal@~. {~ ~. i. ]'

NB.*rankFractional a return the dense ranking ("0 1.5 1.5 3") of array y
NB. Items with the same ranking have the mean of their ordinal ranks.
NB. eg: /: rankFractional 5 2 5 0 6 2 4  NB. rank ascending
NB. eg: \: rankFractional 5 2 5 0 6 2 4  NB. rank descending
rankFractional=: 1 : '(] (+/ % #)/. u rankOrdinal) {~ ~. i. ]'

NB. =========================================================
NB.*cile v   x cile values of y
NB. eg: 3 cile i.12
cile=: $@] $ ((* <.@:% #@]) /:@/:@,)

NB. =========================================================
NB.*dstat v descriptive statistics
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

NB. =========================================================
NB.*histogram v histogram
NB. x is a list of interval start points.
NB. y is an array of data.
NB. The result is a list of counts of the number of data points in each interval.
histogram=: <: @ (#/.~) @ (i.@#@[ , I.)

NB. =========================================================
NB.*kurtosis v  4th moment coefficient
kurtosis=: # * +/@(^&4)@dev % *:@ssdev

NB. =========================================================
NB.*skewness v  3rd moment coefficient
skewness=: %:@# * +/@(^&3)@dev % ^&1.5@ssdev
