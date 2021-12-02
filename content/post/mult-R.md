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

Long time ago I built R-4.0.3 on Ubuntu system by following this [guide](https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-18-04-quickstart) or this [guide](https://cran.r-project.org/bin/linux/ubuntu/). Briefly speaking, I added GPG Key to APT (Advanced Package Tool) and added `CRAN` repository and directly retrieved R by `apt`.
```
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
$ sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
$ sudo apt update
$ sudo apt install r-base
```

Recently, I ran into an issue with `cellassign`. I suspected that reverting to previous R versions might [resolve the problem](https://github.com/Irrationone/cellassign/issues/92).

Plus, the GPG key added earlier is raising errors everytime I invoke `sudo apt update`, which is quite annoying. So I figured it might be better to build R from source.

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

Then remove `cran` repository from `apt` repository list:
```
sudo vim /etc/apt/sources.list
```


Before uninstalling R, check what packages are currently installed and back them up, in case they'll be needed later.
```
$ R
R version 4.0.3 (2020-10-10) -- "Bunny-Wunnies Freak Out"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

> .libPaths()
[1] "/home/luolab/R/x86_64-pc-linux-gnu-library/4.0"
[2] "/usr/local/lib/R/site-library"
[3] "/usr/lib/R/site-library" # This one is empty
[4] "/usr/lib/R/library"
```

In shell, backup the content listed in these paths.
```
$ cp -r /home/luolab/R/x86_64-pc-linux-gnu-library/ /media/luolab/4A9623FA9623E563/R_bak/home.luolab.R.x86_64-pc-linux-gnu-library  # Moving to 120G SSD
$ cp -r /usr/local/lib/R/site-library/ /media/luolab/4A9623FA9623E563/R_bak/usr.local.lib.R.site-library
$ cp -r /usr/lib/R/library/ /media/luolab/4A9623FA9623E563/R_bak/usr.lib.R.library
```

Now actually uninstall R. From shell, do:
```
$ sudo apt-get --purge remove r-base-core
$ sudo apt-get autoremove
```

Make sure R is properly removed:
```
$ R

Command 'R' not found, but can be installed with:

sudo apt install r-base-core
```

### Install R from precompiled binaries

I will use the method listed in this page for installation of R:
[**Install R**](https://docs.rstudio.com/resources/install-r/)*

```
$ sudo apt-get update
$ sudo apt-get install gdebi-core
```

Specify R version.
```
export R_VERSION=4.0.5
```

Download and install the desired version of R.
```
curl -O https://cdn.rstudio.com/r/ubuntu-1804/pkgs/r-${R_VERSION}_1_amd64.deb
sudo gdebi r-${R_VERSION}_1_amd64.deb
```

Verify R installation:
```
/opt/R/${R_VERSION}/bin/R --version
```

To ensure that R is available on the default system `PATH` variable, create symbolic links to the version of R just installed.
```
sudo ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
sudo ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript
```
This step only applies to the first installation of R on a given system. For subsequent installations, this section should be skipped.


To install multiple versions of R, repeat these steps to specify, download, and install a different version of R alongside existing versions.






[System Dependency Detection](https://docs.rstudio.com/rspm/admin/appendix/system-dependency-detection/)

[**Installing multiple versions of R on Linux**](https://support.rstudio.com/hc/en-us/articles/215488098-Installing-multiple-versions-of-R-on-Linux)*

[Using multiple versions of R with RStudio Workbench / RStudio Server Pro](https://support.rstudio.com/hc/en-us/articles/212364537-Using-multiple-versions-of-R-with-RStudio-Workbench-RStudio-Server-Pro)

[Changing R versions for the RStudio Desktop IDE](https://support.rstudio.com/hc/en-us/articles/200486138-Changing-R-versions-for-the-RStudio-Desktop-IDE)

