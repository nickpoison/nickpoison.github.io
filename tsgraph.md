# &#128018;&#128018; R you kidding &#128018;&#128018;

## Time Series and Graphics in R

This is a resurrection of the _Time Series and Graphics_ page that had been discontinued.  The [R Time Series Issues](https://nickpoison.github.io/) is back with more issues than ever before.

For this page, we'll use Vanilla R, [astsa](https://github.com/nickpoison/astsa), and [ggplot2](https://CRAN.R-project.org/package=ggplot2). We used to include demonstrations from the `ggfortify` package, but it was changed so often that eventually most of the examples didn't work. 



### Table of Contents
* [Displays 1 - simple but effective](#displays-1---simple-but-effective)
* [Displays 2 - two series](#displays-2---two-series)
* [Displays 3 - many series](#displays-3---many-series)


You'll need two packages to reproduce the examples. All the data used in the examples are from [astsa](https://github.com/nickpoison/astsa).
```r
install.packages(c("astsa", "ggplot2"))
```


&#x1F4A1; You may also want to check out the [Cairo](https://CRAN.R-project.org/package=Cairo)
package to create high-quality graphics.  It's not necessary, but it sure looks nice. The package is built into R, but needs to be loaded (don't we all?) `library(Cairo)`.

<br/><br/>

---
### Displays 1 - simple but effective
---

&#128526; First, here's a plot of `gtemp_land` using the base graphics. If you add a grid after you plot, it goes on top. You have some work to do if you want the grid underneath... but at least you can work around that - read on.

```r
# for a basic plot, all you need is
plot(gtemp_land)                    # it can't get simpler than that (not shown)
plot(gtemp_land, type='o', col=4)   # a slightly nicer version (not shown)
                                              
# but here's a pretty version using Vanilla R that includes a grid (not shown)
par(mar=c(2,2,0,.5)+.5, mgp=c(1.6,.6,0))                   # trim the margins       
plot(gtemp_land, ylab='Temperature Deviations', type='n')    # set up the plot
grid(lty=1, col=gray(.9))                                  # add a grid
lines(gtemp_land, type='o', col=4)                         # and now plot the line
```

The reason we're not showing the above is that you can get all that and more with [astsa](https://github.com/nickpoison/astsa).

```r 
# in astsa, it's a one liner
tsplot(gtemp_land, type='o', ppch=20, col=4, ylab='Temperature Deviations')
```

![](figs/gtemp.png)

&#x1F535; And a `ggplot2` of the gtemp series. `ggplot2` doesn't play with time series so you have to create a data frame that strips the series to its bare naked data.

```r
gtemp.df = data.frame(Time=c(time(gtemp_land)), gtemp=c(gtemp_land)) # strip the ts attributes
ptemp    = ggplot(data = gtemp.df,  aes(x=Time, y=gtemp) )   +   # store it
                  ylab('Temperature Deviations')             +
                  geom_line(col="blue")                      +
                  geom_point(col="blue", pch=1)
ptemp                                                            # plot it    

# To remove the gray background, run 
ptemp + theme_bw()       # not shown  
```

![](figs/gtemp2.png)

It's not necessary to store the figure... it's just an example of what you can do.

&#128520; If you like the gray background with white grid lines, you can do a gris-gris plot with `astsa` (the grammar of `astsa` is voodoo)

```r
tsplot(gtemp_land, gg=TRUE, type='o', pch=20, col=4, ylab='Temperature Deviations')
```

![](figs/gtemp3.png)

[<sub>top</sub>](#table-of-contents)

<br/>

---
### Displays 2 - two series
---

&#128125; Time to get a little more complex by plotting two series that touch each other (but in a nice way) on the same plot.  We'll get to the general stuff soon.

&#x1F535; Here's an example of `ggplot` for two time series, one at a time (not the best way for many time series).

```r
gtemp.df    = data.frame(Time=c(time(gtemp_land)), gtemp=c(gtemp_land), gtemp2=c(gtemp_ocean))
ggplot(data = gtemp.df, aes(x=Time, y=value, color=variable )  )             +
              ylab('Temperature Deviations')                                 +
              geom_line(aes(y=gtemp , col='Land Only'),  size=1, alpha=.5)   +
              geom_line(aes(y=gtemp2, col='Ocean Only'), size=1, alpha=.5)   +
              theme(legend.position=c(.1,.85))			  
```

![](figs/gtemp4.png)

<br/>

&#x1F535;  Now the same idea using `tsplot` from `astsa` with the `spaghetti` option.
There are more examples at [FUN WITH ASTSA](https://github.com/nickpoison/astsa/blob/master/fun_with_astsa/fun_with_astsa.md), where the fun never stops.

```r
tsplot(cbind(gtemp_land,gtemp_ocean), col=astsa.col(c(2,5),.5), lwd=2, gg=TRUE,
          ylab='Temperature Deviations', spaghetti=TRUE)
legend("topleft", legend=c("Land Only","Ocean Only"), col=c(2,5), lty=1, bty="n")
```

![](figs/gtemp5.png)

[<sub>top</sub>](#table-of-contents)

<br/>

---
### Displays 3 - many series
---

&#128125; Let's start with `ggplot2`. We're going to plot the


