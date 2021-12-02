---
title:       "Build Multiple R Versions on Linux"
subtitle:    ""
description: ""
date:        2021-12-02T19:54:09+08:00
author:      Ruiyu Wang
image:       ""
tags:        ["R", "Rstudio", "Ubuntu"]
categories:  ["Tech" ]
---

Long time ago I built R-4.0.3 on Ubuntu system by following this [guide](https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-18-04-quickstart). Briefly speaking, I added GPG Key to APT (Advanced Package Tool) and added `CRAN` repository and directly retrieved R by `apt`.
```
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
$ sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
$ sudo apt update
$ sudo apt install r-base
```

Recently, I ran into an issue with `cellassign`. I suspected that reverting to previous R versions might [resolve the problem](https://github.com/Irrationone/cellassign/issues/92).

Plus, the GPG key added earlier is raising errors everytime I invoke `sudo apt update`, which is quite annoying. So I figured it might be better to build R from source. I did a little bit of research and found these links might help:

[**Installing multiple versions of R on Linux**](https://support.rstudio.com/hc/en-us/articles/215488098-Installing-multiple-versions-of-R-on-Linux)*

[Using multiple versions of R with RStudio Workbench / RStudio Server Pro](https://support.rstudio.com/hc/en-us/articles/212364537-Using-multiple-versions-of-R-with-RStudio-Workbench-RStudio-Server-Pro)

[Changing R versions for the RStudio Desktop IDE](https://support.rstudio.com/hc/en-us/articles/200486138-Changing-R-versions-for-the-RStudio-Desktop-IDE)

[**Install R**](https://docs.rstudio.com/resources/install-r/)*

[System Dependency Detection](https://docs.rstudio.com/rspm/admin/appendix/system-dependency-detection/)

### Uninstall previously built R versions

First check GPG Keys added by previous R built and remove it.
```
$ sudo apt-key list
```
```
pub   rsa4096 2019-06-11 [SC]
      4A0C 1931 1880 3EB4 A561  E569 B3CF 35C3 15B5 5A9F
uid           [ unknown] Launchpad PPA for cran

/etc/apt/trusted.gpg.d/ubuntu-keyring-2012-archive.gpg
```
```
$ sudo apt-key del "4A0C 1931 1880 3EB4 A561  E569 B3CF 35C3 15B5 5A9F"
```

Before uninstalling R, check what packages are currently installed and back them up, in case they'll be needed later.
```
$ R
> .libPaths()
```
```
```