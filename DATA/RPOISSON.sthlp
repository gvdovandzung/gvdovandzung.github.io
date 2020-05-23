Poisson regression with random effects
--------------------------------------

^rpoisson^ [varlist] [^if^ exp] [^in^ range] [^,^ ^rd^en^(^varname^) 
             fv^ar^(^#^) g^roup^(^varlist^) h^uber l^evel^(^#^) no^l^og]

Description
-----------

^rpoisson^ fits a log-linear poisson regression model with random
effects ("frailties"). The model is assumed to apply to the rates
obtained by dividing the expected value of an event count by a rate
denominator (such as the "person-years" of observation, or "exposure").
Frailties are random rate multipliers, assumed to be drawn from a 
gamma distribution with unit mean and unknown variance. The ^group^
option defines subgroups all members of which  share the same frailty.
If this option is not specified, frailty is  assumed to operate at the
level of the individual unit and the model becomes the same as the
negative binomial model for overdispersed counts (see [5s] nbreg, [5s]
glm, nbpar).

As usual for regression commands, the variable list should start with
the dependent variable (the event count), followed by the explanatory
variables. 

Optionally, Huber's formula may be used to estimate standard errors of
the fixed effect coefficients. This option need not be invoked in the
first call to ^rpoisson^, but may be specified in a later call (without 
a varlist).

Options
-------

^exposure(^varname^)^ supplies the variable which contains the rate 
denominators.

^group(^varlist^)^ defines the groups of observations which share the
same frailty.

^huber^ specifies that Huber standard errors are to be calculated for
the regression coefficients (see [5s] huber). When the model is first
fitted, the usual model-based standard errors are listed also.

^ir^ specifies that regression coefficients are to be displayed in their
exponentiated form, as rate-ratios.

^fvar(^#^)^ provides an initial value for the frailty variance. This
will usually only be needed if difficulty is experienced obtaining
convergence of the iterations.

^level(^#^)^ gives the level for the confidence intervals (default 95).

^nolog^ turns off the iteration log

Note that ^huber^ and ^ir^ may be invoked when "replaying" a previously
fitted model. However, once ^huber^ has been used, the Huber standard
errors will remain in force for all subsequent replays.

Examples
--------

^rpoisson d x1 x2, rd(y) gr(id)^  - fit model to observations grouped by ^id^

^rpoisson , ir^                   - display coefficients as rate ratios

^rpoisson , h^                    - calculate Huber standard errors

^rpoisson , ir^                   - new confidence intervals for rate ratios

Also see
--------

[5s] glm, [5s] huber, [5s] nbreg, nbpar




