# &#128018;&#128018; R you kidding &#128018;&#128018;

## Time Series and Graphics in R

This is a resurrection of the _Time Series and Graphics_ page that had been discontinued.  The [R Time Series Issues](https://nickpoison.github.io/) is back with more issues than ever before.

For this page, we'll use Vanilla R, [astsa](https://github.com/nickpoison/astsa), and [ggplot2](https://CRAN.R-project.org/package=ggplot2). We used to include demonstrations from the `ggfortify` package, but it was changed so often that eventually most of the examples didn't work. 



### Table of Contents
* [Part 1 - simple but effective](#part-1---simple-but-effective)
* [Part 2 - two series](#part-2---two-series)
* [Part 3 - many series](#part-3---many-series)
* [Part 4 - missing data](#part-4---missing-data)


You'll need two packages to reproduce the examples. All the data used in the examples are from [astsa](https://github.com/nickpoison/astsa).
```r
install.packages(c("astsa", "ggplot2"))
```


&#x1F4A1; You may also want to check out the [Cairo](https://CRAN.R-project.org/package=Cairo)
package to create high-quality graphics.  It's not necessary, but it sure looks nice. The package is built into R, but needs to be loaded (don't we all?) `library(Cairo)`.

<br/>

### &#10024; The [R Time Series Issues](https://nickpoison.github.io/) page is also alive.

<br/><br/>

---
### Part 1 - simple but effective
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
### Part 2 - two series
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
### Part 3 - many series
---

&#x1F535; Let's start with `ggplot2`. We're going to plot the 8 explosion series.

```r
library(reshape)            # install 'reshape' if you don't have it
df   = melt(eqexp[,9:16])   # reshape the data frame
Time = rep(1:2048, 8)
ggplot(data=df, aes(x=Time, y=value, col=variable))   +
     geom_line( )                                     +
     theme(legend.position="none")                    +
     facet_wrap(~variable, ncol=2, scales='free_y')   +
     ylab('')	
```

![](figs/ggexp.png)

<br/>

&#129299; Now let's try the same thing with `tsplot`. It's not necessary to make it a gris-gris plot so remove the `gg=TRUE` part if you dare.  You don't have to melt anything.

```r
tsplot(eqexp[,9:16], col=1:8, ncol=2, gg=TRUE)
```

![](figs/tsexp.png)

<br/>

&#128530; Let's do another `ggplot` with more than 2 series on the same plot. The script does not work with time series so you have to spend some time removing the time series attributes.  You could try `ggfortify` ... it might work now, but we're not going to touch it because we've been burned before.

&#128549;  We're going to use 3 series from the LA Pollution study from `astsa`.  The data are weekly time series, so we're removing the attributes first.

```r
mortality    = c(cmort)  # cardiovascular mortality
temperature  = c(tempr)  # termperature
pollution    = c(part)   # particulate pollution
df   = melt(data.frame(mortality, temperature, pollution))
Time = c(time(cmort), time(tempr), time(part))
ggplot(data=df, aes(x=Time, y=value, col=variable)) +
    geom_line( )                                    +
    ylab("LA Pollution Study")
```

![](figs/gglap.png)

<br/>

&#128527;  This is how we would do it using `tsplot`.  The first line takes the `astsa` colors magenta, green, and blue, and makes them a little transparent (alpha=.7). Also, `spaghetti` is shortened to `spag`.

```r
culer = astsa.col(c(6,3,4), .7)
tsplot(cbind(cmort,tempr,part), ylab='LA Pollution Study', col=culer, spag=TRUE)
legend('topright', legend=c('Mortality', 'Temperature', 'Pollution'), 
             lty=1, lwd=2, col=culer, bg='white')

```

![](figs/tslap.png)

[<sub>top</sub>](#table-of-contents)

<br/>


---
### Part 4 - missing data
---

&#128518; In base graphics, it is sooooooo simple and the result is decent (not shown). The data set `blood` has lots of `NA`s.  You need a to have points (`type='o'` here) to get the stuff that can't be connected with lines.

```r
plot(blood, type='o', pch=19, main='')   
```

&#128525; Here it is using `astsa`:

```r
tsplot(blood, type='o', col=c(4,6,3), pch=19, cex=1, gg=TRUE)  
```

![](figs/tsblood.png)

&#127881; &#127880; Nothing to it! &#127880; &#127881;

<br/>

![](figs/slaphead.gif) So, here it is with `ggplot2`. It works ok, but you get warnings and other frustrations you'll see along the way...

```r
# make a data frame removing the time series attributes
df = data.frame(day=c(time(blood)), blood=c(blood), Type=factor(rep(c('WBC','PLT','HTC'), each=91)) )

# notice that the factor levels of Type are in alphabetical order...
levels(df$Type)           
   [1] "HTC" "PLT" "WBC"

# ... if I don't use the next line, the plot will be in alphabetical order ... 
# ... if I wanted the series in alphabetical order ...
# ... I would have ordered it that way - so I need ...
# ... the next line to reorder them back to the way I entered the data   ...
df$Type = factor(df$Type, levels(df$Type)[3:1])  
 
# any resemblance to the blood work of actual persons, living or dead, is purely coincidental
ggplot(data=df, aes(x=day, y=blood, col=Type))       +
       ylab("Mary  Jane's  Blood  Work")             +   
       geom_line()                                   +
       geom_point()                                  +
       theme(legend.position="none")                 +
       facet_wrap(~Type, ncol=1, scales='free_y')
   
# Danger, Will Robinson! Warning! Warning! NAs appearing! 	   
 Warning messages:
 1: Removed 9 rows containing missing values (geom_path).      
 2: Removed 111 rows containing missing values (geom_point).  
# We're doomed! Crepes suzette! 
```

![](figs/ggblood.png)

We're not done.  At least we got the plot after some work and warnings. But notice that the vertical axes have to have a common name.  If you want individual labels (e.g., WBC is measured in 10<sup>3</sup>/&mu;L) then you're in a load of &#128169;&#128169;&#128169;  ... we guess that's not in the grammar of graphics, too.). Anyway, we found this a long time ago if you want to force the matter: [how to plot differently scaled multiple time series with ggplot2](https://gist.github.com/tomhopper/faa24797bb44addeba79).

