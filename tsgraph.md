# &#128018;&#128018; R you kidding &#128018;&#128018;


### Table of Contents

 * [**Time Series and Graphics in R**](#time-series-and-graphics-in-r)
    * [Example 1](#example-1---simple-but-effective)



## Time Series and Graphics in R

We'll use Vanilla R, [astsa](https://github.com/nickpoison/astsa), and [ggplot2](https://CRAN.R-project.org/package=ggplot2). We used to include demonstrations from the `ggfortify` package, but it was changed so often that eventually most of the examples didn't work. 

You'll need two packages to reproduce the examples:
```r
install.packages(c("astsa", "ggplot2"))
```

---
### Example 1 - simple but effective
---

First, here's a plot of `globtemp` using the base graphics. If you add a grid after you plot, it goes on top. You have some work to do if you want the grid underneath... but at least you can work around that - read on.

```r
# for a basic plot, all you need is
plot(globtemp)                    # it can't get simpler than that (not shown)
plot(globtemp, type='o', col=4)   # a slightly nicer version (not shown)
                                              
# but here's a pretty version that includes a grid 
par(mar=c(2,2,0,.5)+.5, mgp=c(1.6,.6,0))                   # trim the margins       
plot(globtemp, ylab='Temperature Deviations', type='n')    # set up the plot
grid(lty=1, col=gray(.9))                                  # add a grid
lines(globtemp, type='o', col=4)                           # and now plot the line
```

![]

```r 
# in astsa, it's a one liner
tsplot(soi, main='Southern Oscillation Index', col=4)
```