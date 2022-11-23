# Math Kernel Libraries in R 

## The Bottom Line (at the top) 

Revolutions R came along around 2007 and provided more powerful R computing... it was freeware, but as I 
recall you had to register to get it.  A few years later, Microsoft bought it and called it __Microsoft
R Open__.  It is freeware, no registration needed. The current version is 4.0 with no word from the company about updates and future support. [Get it here](https://mran.microsoft.com/).

The nice feature with Microsoft R Open is that it is stable.  

> Microsoft R Open is the enhanced distribution of R from Microsoft Corporation. The current release, Microsoft R Open 4.0.2, is based the statistical language R-4.0.2 and includes additional capabilities for improved performance, reproducibility and platform support.

For reproducibility, packages are frozen in time so that if it worked last year, it will work today.  They also have a time machine that keeps packages back to 2014.

In addition, Microsoft R Open includes multi-threaded math libraries to improve the performance of R.     These libraries make it possible for so many common R operations, such as matrix multiply/inverse, matrix decomposition, and some higher-level matrix operations, to compute in parallel and use all of the processing power available to reduce computation times.

<br/>

---

## Using the Intel MKL with the current version of R

These notes are for Windows. If you run Linux, then go to [MKL4DEB](https://github.com/eddelbuettel/mkl4deb) for details.

Before you start, try this and save the results:
```r
# Singular Value Decomposition
m <- 10000
n <- 2000
A <- matrix (runif (m*n),m,n)
system.time (S <- svd (A,nu=0,nv=0)) 
```


This is an easy approach mentioned in the discussion on Stackoverflow [Linking Intel's Math Kernel Library  to R on Windows](https://stackoverflow.com/questions/38090206/linking-intels-math-kernel-library-mkl-to-r-on-windows/56560870#56560870).




*  Get and install [Intel MKL](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html#gs.j05ihm). Go over there and look around to see your options, you may have to register.

Once you receive and install the libraries,

* Go to the folder  <br/> <br/>
&emsp; `C:\Program Files (x86)\IntelSWTools\compilers_and_libraries_XXX\windows\redist\intel64\`  <br/> <br/>
where `XXX` is the latest version date (for me, `XXX = 2020.2.254`). Paste all the CONTENT from the folders `complier` and `mkl`  into the directory where R is installed, something like `C:\Program Files\R\R-4.x.x\bin\x64\`.

*    Change `Rlapack.dll` and `Rblas.dll` in the R directory to `Rlapack.dll.bak`  and `Rblas.dll.bak`, respectively as backups.

*  Inside the destination folder, create __TWO (2)__ copies of `mkl_rt.dll`  and rename those  as `Rlapack.dll` and `Rblas.dll`  and keep `mkl_rt.dll`.  


Go back and run the SVD - if you did everything correctly, you will see a marked difference.









<br/><br/><br/><br/><br/><br/>




