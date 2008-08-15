NB. univariate

NB.*mean v         arithmetic mean
NB.*geomean v      geometric mean
NB.*harmean v      harmonic mean
NB.*commonmean     common mean
NB.
NB.*dev v          deviation from mean
NB.*ssdev v        sum squares of deviation
NB.*var v          variance
NB.*stddev v       standard deviation
NB.*skewness v     skewness
NB.*kurtosis v     kurtosis
NB.
NB.*min v          minimum
NB.*max v          maximum
NB.*midpt v        index of midpoint
NB.*median v       median
NB.
NB.*dstat v        descriptive statistics
NB.*freqcount v    frequency count
NB.*histogram v    histogram

mean=: +/ % #
geomean=: */ %:~ #
harmean=: mean &.: %
commonmean=: [: {. (%:@*/ , -:@+/) ^: _

dev=: -"_1 _ mean
ssdev=: +/ @: *: @ dev
var=: ssdev % <:@#
stddev=: %: @ var

NB. "p" suffix = population definitions
varp=: ssdev % #
stddevp=: %: @ varp

min=: <./
max=: >./
midpt=: -:@<:@#
median=: -:@(+/)@((<. , >.)@midpt { /:~)

NB. =========================================================
NB. descriptive statistics
dstat=: 3 : 0
t=. '/sample size/minimum/maximum/median/mean'
t=. t,'/std devn/skewness/kurtosis'
t=. ,&':  ' ;._1 t
v=. $,min,max,median,mean,stddev,skewness,kurtosis
t,. ": ,. v y
)

NB. =========================================================
NB. frequency count (value, frequency) sorted by decreasing frequency
freqcount=: (\: {:"1)@(~. ,. #/.~)

NB. =========================================================
NB. histogram
NB. x is a list of interval start points.
NB. y is an array of data.
NB. The result is a list of counts of the number of data points in each interval.
histogram=: <: @ (#/.~) @ (i.@#@[ , I.)

NB. =========================================================
NB. kurtosis = 4th moment coefficient
kurtosis=: # * +/@(^&4)@dev % *:@ssdev

NB. =========================================================
NB. skewness = 3rd moment coefficient
skewness=: %:@# * +/@(^&3)@dev % ^&1.5@ssdev
