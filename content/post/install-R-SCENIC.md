---
title:       "R SCENIC：安装与部署"
date:        2021-12-22T12:32:17+08:00
tags:        ["Single Cell Biology", "Ubuntu", "SCENIC"]
categories:  ["Bioinformatics" ]
---

# TL;DR

First consulted [this page](http://htmlpreview.github.io/?https://github.com/aertslab/SCENIC/blob/master/inst/doc/SCENIC_Setup.html)

I have `R-4.0.5` with `Bioconductor 3.12(4.0)`, use the latest scripts for installation.

In Rstudio:
```
> if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
> BiocManager::version()
> # If your bioconductor version is previous to 4.0, see the section bellow
> 
> ## Required
> BiocManager::install(c("AUCell", "RcisTarget"))
> BiocManager::install(c("GENIE3")) # Optional. Can be replaced by GRNBoost
> 
> ## Optional (but highly recommended):
> # To score the network on cells (i.e. run AUCell):
> BiocManager::install(c("zoo", "mixtools", "rbokeh"))
> # For various visualizations and perform t-SNEs:
> BiocManager::install(c("DT", "NMF", "ComplexHeatmap", "R2HTML", "Rtsne"))
> # To support paralell execution (not available in Windows):
> BiocManager::install(c("doMC", "doRNG"))
> > # To export/visualize in http://scope.aertslab.org
> if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
> devtools::install_github("aertslab/SCopeLoomR", build_vignettes = TRUE)
```
These worked fine.

Then, when installing SCENIC using `devtools`:
```
> if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
> devtools::install_github("aertslab/SCENIC") 
Downloading GitHub repo aertslab/SCENIC@HEAD
Error in utils::download.file(url, path, method = method, quiet = quiet,  : 
  download from 'https://api.github.com/repos/aertslab/SCENIC/tarball/HEAD' failed
```

Tried several times with no success.

There are some discussions on this behavior with `devtools` and `remotes`, for example this [issue](https://github.com/r-lib/remotes/issues/130), but I find it un-straightforward.

Instead, I decided to switch to SCENIC(R) github page and install directly from there. 
First tried directly cloning the repo:
```
$ git clone https://github.com/aertslab/SCENIC.git
Cloning into 'SCENIC'...
fatal: unable to access 'https://github.com/aertslab/SCENIC.git/': Could not resolve host: github.com
```
This also failed!

Then tried `Download ZIP` to local and unzip `SCENIC-master.zip`. Create a new project in Rstudio from the directory containing SCENIC build and hit the `Install and Restart` button. 

This also failed because of an error of the sort "Dependency 'dynamicTreeCut' not available", but this won't be very difficult to solve.

Install `dynamicTreeCut` manually:
```
> install.packages("dynamicTreeCut")
Warning in install.packages :
  unable to access index for repository https://cran.rstudio.com/src/contrib:
  cannot open URL 'https://cran.rstudio.com/src/contrib/PACKAGES'
Installing package into ‘/home/luolab/R/x86_64-pc-linux-gnu-library/4.0’
(as ‘lib’ is unspecified)
Warning in install.packages :
  unable to access index for repository https://cran.rstudio.com/src/contrib:
  cannot open URL 'https://cran.rstudio.com/src/contrib/PACKAGES'
Warning in install.packages :
  package ‘dynamicTreeCut’ is not available for this version of R

A version of this package for your version of R might be available elsewhere,
see the ideas at
https://cran.r-project.org/doc/manuals/r-patched/R-admin.html#Installing-packages
```

To [fix this](https://community.rstudio.com/t/install-packages-unable-to-access-index-for-repository-try-disabling-secure-download-method-for-http/16578), in Rstudio go to `Tools` > `Global Options` > `Packages` and **Uncheck** `Use secure download method for HTTP`. Then:
```
> install.packages("dynamicTreeCut")
Installing package into ‘/home/luolab/R/x86_64-pc-linux-gnu-library/4.0’
(as ‘lib’ is unspecified)
trying URL 'http://cran.rstudio.com/src/contrib/dynamicTreeCut_1.63-1.tar.gz'
Content type 'application/x-gzip' length 24027 bytes (23 KB)
==================================================
downloaded 23 KB

* installing *source* package ‘dynamicTreeCut’ ...
** package ‘dynamicTreeCut’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** byte-compile and prepare package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded from temporary location
** testing if installed package can be loaded from final location
** testing if installed package keeps a record of temporary installation path
* DONE (dynamicTreeCut)

The downloaded source packages are in
	‘/tmp/RtmpgfV9Bj/downloaded_packages’
```
Success!

Now `Install and Restart` SCENIC again and everything worked.

Next job is to import `pySCENIC` results to R `SCENIC`, consult the followings:

- [Github issue discussion](https://github.com/aertslab/pySCENIC/issues/180)
- [Vignette](https://rawcdn.githack.com/aertslab/SCENIC/0a4c96ed8d930edd8868f07428090f9dae264705/inst/doc/importing_pySCENIC.html)

## P.S.

When trying to push this post to github remote, failed again...
```
$ git push -u --all
fatal: unable to access 'https://github.com/RuiyuRayWang/blog.git/': Could not resolve host: github.com
```

Looks like we're having a bad day with github server...
