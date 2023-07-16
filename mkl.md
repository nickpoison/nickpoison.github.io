
# Linking MKL to R on Windows

&#128176; I'm still using this on R version 4.3.0 and it works fine. 

<br/>

## &#128038; The Bottom Line (at the top)

Revolutions R came along around 2007 and provided more powerful R computing... it was freeware, but as I recall you had to register to get it.  A few years later, Microsoft bought it and called it _Microsoft R Open_.  Unfortunately, it will be gone soon if not gone already.
Here is a work around from the discussion on [Stackoverflow - Linking Intel's Math Kernel Library (MKL) to R on Windows](https://stackoverflow.com/questions/38090206/linking-intels-math-kernel-library-mkl-to-r-on-windows/56560870#56560870). 


These notes are for Windows. If you run Linux, go to [MKL4DEB](https://github.com/eddelbuettel/mkl4deb) for details.


Before you start, do this and record how flippin' long it takes to run:

```r
# Singular Value Decomposition
m <- 10000
n <- 2000
A <- matrix (runif (m*n), m, n)
system.time (S <- svd (A, nu=0, nv=0))
```

Now close R and let the magic begin ...

---

<br/>

## &#128038; Steps to Enhance  R version 4 

This is an easy update as described in the discussion on [Stackoverflow](https://stackoverflow.com/questions/38090206/linking-intels-math-kernel-library-mkl-to-r-on-windows/56560870#56560870) previously mentioned.


-   Download the library files from here (it's an archive with 2 directories)
[libraries.zip](https://www.stat.pitt.edu/stoffer/tsa4/libraries.zip) and extract everything.

- Go to the  directory where R is installed, something like `C:\Program Files\R\R-4.xxx\bin\x64\`, and change `Rlapack.dll` and `Rblas.dll` to
`Rlapack.dll.bak` and `Rblas.dll.bak`, respectively, as backups.

- From the extracted folder in step 1, paste all the content from the folders
`complier` and  `mkl`  into the  directory where R is installed.


- Inside the destination folder, create **2** (additional) copies of `mkl_rt.dll`  and rename the new files as `Rlapack.dll` and `Rblas.dll`  and keep `mkl_rt.dll`.  

- Start R and rerun the SVD code and be amazed &#128515; at the difference in computation time.


<br/><br/><br/><br/><br/><br/>

---
---


							








