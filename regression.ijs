NB. regression
NB.
NB.*regression v   multiple regression

NB. =========================================================
NB. regression
NB. syntax:  independent regression dependent
NB.    dependent = vector of n observations (Y value)
NB.  independent = n by p matrix of n observations for p independent
NB.                variables (X value)
NB.
NB. returns formatted values
regression=: 4 : 0
v=. 1,.x
d=. y
b=. d %. v
k=. <:{:$v
n=. $d
sst=. +/*:d-(+/d) % #d
sse=. +/*:d-v +/ .* b
mse=. sse%n->:k
seb=. %:({.mse)*(<0 1)|:%.(|:v) +/ .* v
ssr=. sst-sse
msr=. ssr%k
rsq=. ssr%sst
F=. msr%mse

r=. ,: '             Var.       Coeff.         S.E.           t'
r=. r, 15 15j5 15j5 12j2 ": (i.>:k),.b,.seb,.b%seb
r=. r, ' '
r=. r, '  Source     D.F.        S.S.          M.S.           F'
r=. r, 'Regression', 5 15j5 15j5 12j2 ": k, ssr,msr,F
r=. r, 'Error     ', 5 15j5 15j5 ": (n-k+1), sse,mse
r=. r, 'Total     ', 5 15j5 ": (n-1), sst
r=. r, ' '
r=. r, 'S.E. of estimate    ', 12j5 ":%:mse
r=. r, 'Corr. coeff. squared', 12j5 ": rsq
)
