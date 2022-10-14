# &#128018;&#128018; R you kidding &#128018;&#128018;



### Table of Contents
  * [R Time Series Issues is back](#hello-you---were-back-at-trying-to-help-you-get-past-the-gnarly-stuff-that-comes-with-trying-to-use-r-for-time-series-this-is-an-update-of-the-r-issues-page-wherein-it-is-written-on-whatever-they-write-it-on-up-there)
    * [Issue 1. when is a matrix not a matrix](#issue-1---r-you-kidding)
    * [Issue 2. package fights](#issue-2-how-will-r-end)
    * [Issue 3. artificially stupid intelligence](#issue-3-dont-use-autoarima)
    * [Issue 4. when is the intercept the mean](#issue-4-when-is-the-intercept-the-mean)
    * 

###  Hello You - we're back at trying to help You get past the gnarly stuff that comes with trying to use R for time series. This is an update of the [R Issues Page](https://www.stat.pitt.edu/stoffer/tsa4/Rissues.htm) wherein it is written, on whatever they write it on up there: 


> There are a few items related to the analysis of time series with R that will have you scratching your head. The issues mentioned below are meant to help get you past the sticky points. 







<br/>

---

###  ISSUE 1 - R you kidding? 

---

&#128544; You have a time series of matrices, say _A<sub>t</sub>_ that are of arbitrary dimensions _p x q_ for _t = 1, &#8230; , n_.  You would use an `array` right?  BUT, and this is a big BUT, the behavior changes with _p_ and _q_.  Let's have a closer look: 

```r
# 5 2 by 2 matrices
A = array(diag(1,2), dim=c(2, 2, 5))
is.matrix(A[,,2])
  [1] TRUE  ok - a matrix

# 5 1 by 2 matrices 
B = array(matrix(1,2), dim=c(2, 1, 5))
is.matrix(B[,,2])
  [1] FALSE  WTF? not a matrix

# 5 2 by 1 matrices 
C = array(matrix(2,1), dim=c(1, 2, 5))
is.matrix(C[,,2])
  [1] FALSE  WTF? not a matrix
```

What's happening is if _p_ or _q_ are 1, then you don't get an array of matrices.
What can go wrong?

```r 
# should be a 2x1 times a 1x2 or 2x2 - BUT IT'S NOT!
B[,,1]%*%C[,,1]
#       [,1]
# [1,]    4

# this doesn't work either
as.matrix(B[,,1])%*%as.matrix(C[,,1])
# Error in as.matrix(B[, , 1]) %*% as.matrix(C[, , 1]) : 
#  non-conformable arguments
```
What's the remedy? Use Matlab, or make sure your matrices are the matrices you intended them to be:

```r
# like this
 matrix(B[,,1], 2, 1)%*%matrix(C[,,1], 1, 2)
#      [,1] [,2]
# [1,]    2    2
# [2,]    2    2
```

&#9997; Now back to our regularly scheduled list of screw ups.

<br/>

---

### Issue 2:  how will R end?   
---

&#9989; 
The issue below has become a real pain as  the commercial enterprise that makes RStudio (aka Postit &#128210; ) influences the R Foundation, which is a nonprofit organization.  Older folks saw this happen with R's predecessor, S-PLUS.  Anybody using S-PLUS right now?
  
 
An   issue with a conflict between the package  `dplyr`  and  `stats`  package  came to my attention recently; in particular `filter()` and `lag()`. There may be more but the conflict can ruin you analyses.

 The bottom line is, if you are working with time
    series and you load  `dplyr`, then you should know what it breaks... just be careful.
	

In fact, you should be careful whenever you load a package.  For example:
```r
# if I do this
library(dplyr)

# I will see this 
 Attaching package: 'dplyr' 

 The following objects are masked from 'package:stats': 

     filter, lag     

 The following objects are masked from 'package:base': 

     intersect, setdiff, setequal, union      

## it's a package fight!   
```
To be safe, load packages consciously and watch for masked objects warnings.  I would say avoid loading `dplyr` if
you're analyzing time series interactively (the advantage of using R vs batch mode programs). 

 
One fix if you're analyzing time series (or teaching a class) is to (tell students to) do the following after loading all the packages needed: 
```r
filter = stats::filter
lag = stats::lag
```

>&#128260; Oh yeah, so you're probably wondering how? ... every package will nullify every other package until one day, you load R and it masks itself in an infinite do loop ...



<br/>

---

### Issue 3:  don't use auto.arima   

---

&#x274C; Don't use black boxes like `auto.arima` from the `forecast` package because IT DOESN'T WORK; see [Using an automated process to select the order of an ARMA time series model returns the true data generating process less than half the time even with simple data generating processes; and with more complex models the chance of success comes down nearly to zero even with long sample sizes.](http://freerangestats.info/blog/2015/09/30/autoarima-success-rates)




![](figs/slaphead.gif) Originally, `astsa` had a version of automatic fitting of models but IT DIDN'T WORK and was scrapped.  The bottom line is, if you don't know what you're doing, then why are you doing it? Maybe a better idea is to [take a short course on fitting ARIMA models to data](https://www.datacamp.com/courses/arima-models-in-r).

&#128055; DON'T BELIEVE IT?? OK... HERE YOU GO:

```r
set.seed(666)
x = rnorm(1000)          # WHITE NOISE
forecast::auto.arima(x)  # BLACK BOX

   # partial output
     Series: x
     ARIMA(2,0,1) with zero mean

     Coefficients:
               ar1      ar2     ma1
           -0.9744  -0.0477  0.9509
     s.e.   0.0429   0.0321  0.0294

     sigma^2 estimated as 0.9657:  log likelihood=-1400
     AIC=2808.01   AICc=2808.05   BIC=2827.64
````

 HA! ... an ARMA(2,1) ??  
 
&#128038; There are lots of examples.  The bottom line here is, automated ARIMA model fitting is for the birds. 

 
<br/>

---

### Issue 4:  when is the intercept the mean?   

---


&#128558; When fitting ARIMA models, R calls the estimate of the mean, the estimate of the intercept. This is ok if there's no AR term, but not if there is an AR term.

For example, if $x_t = \alpha + \phi x_{t-1} + w_t$ is stationary, then taking expectations, 
$\mu = E(x_t)$, we have $\mu =  \alpha + \phi \mu$ or 

$$\alpha=\mu (1-\phi)$$


&#128542; So, the intercept, $\alpha$, is not the mean, $\mu$, unless $\phi= 0$. In general, the mean and the intercept are the same only when there is no AR term. Here's a numerical example:

```r
# generate an AR(1) with mean 50
set.seed(666)      # so you can reproduce these results
x = arima.sim(list(order=c(1,0,0), ar=.9), n=100) + 50 

mean(x)  
  [1] 49.09817   # the sample mean is close

arima(x, order = c(1, 0, 0))  
  Coefficients:
           ar1  intercept   # <--  here is the problem
        0.7476    49.1451   # <--  or here, one of these has to change
  s.e.  0.0651     0.3986
```

The result is telling you the estimated model is something like

$$ x_t = 49 + .75 x_{t-1} + w_t $$

whereas, it should be telling you the estimated model is

$$ x_t - 49 = .75 ( x_{t-1} - 49)+ w_t $$

or

$$ x_t = 12.25 + .75 x_{t-1} + w_t $$
  
&#129300; And if 12.25 is not the intercept, then what is it??

The easy thing (for the R devs) to do is simply change "intercept" to "mean":

```r
  Coefficients:
           ar1       mean  
        0.7476    49.1451
  s.e.  0.0651     0.3986
 ``` 

 This is the main reason `sarima` in the package [`astsa`](https://github.com/nickpoison/astsa) was developed, and frankly, to make up for the fact that time series was an after thought, started the entire [`astsa`](https://github.com/nickpoison/astsa) package in the first place.