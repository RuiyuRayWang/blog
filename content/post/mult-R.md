---
title:       "Clean Built of Multiple R Versions on Linux"
subtitle:    ""
description: ""
date:        2021-12-02T19:54:09+08:00
author:      Ruiyu Wang
image:       ""
tags:        ["R", "Rstudio", "Ubuntu"]
categories:  ["Tech" ]
---

Long time ago I built R-4.0.3 on Ubuntu system by following these guides: [link1](https://www.digitalocean.com/community/tutorials/how-to-install-r-on-ubuntu-18-04-quickstart), [link2](https://cran.r-project.org/bin/linux/ubuntu/). Briefly, I added GPG Key to APT (Advanced Package Tool) and added `CRAN` repository and directly retrieved R by `apt`.
```
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
$ sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran40/'
$ sudo apt update
$ sudo apt install r-base
```

Recently, I ran into an issue with [`cellassign`](https://github.com/Irrationone/cellassign) when analyzing single cell datasets. I suspected that reverting to previous R versions might [resolve the problem](https://github.com/Irrationone/cellassign/issues/92).

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
$ sudo vim /etc/apt/sources.list  # Manually edit, remove entries related to R or cran
```


Before uninstalling R, we might want to check what packages are currently installed and back them up, in case they'll be needed later.
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

Now actually uninstall R. In shell, do:
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

As a prerequisite, enable additional repositories for third-party or source packages:
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

Next, time to install multiple versions of R. Repeat the above steps to specify, download, and install a different version of R alongside existing versions.
I re-configured with `export R_VERSION=3.6.3` and executed the steps above to have R-3.6.3 installed.

### Switching between R versions

The tutorial has a note at the symlink step, saying:
>This step only applies to the first installation of R on a given system. For subsequent installations, this section should be skipped.

I suspect that overriding the symlink with later installed R versions would allow switching between different R versions. So I did:
```
$ export R_VERSION=3.6.3
$ sudo rm /usr/local/bin/R /usr/local/bin/Rscript
$ sudo ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R  # ${R_VERSION}=3.6.3
$ sudo ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript
```

After doing this, R indeed switched to 3.6.3, which is my desired version.
```
$ which R
/usr/local/bin/R
$ file /usr/local/bin/R
/usr/local/bin/R: symbolic link to /opt/R/3.6.3/bin/R
$ R --version
R version 3.6.3 (2020-02-29) -- "Holding the Windsock"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)
```

Another way of switching between different R versions is to get `Rstudio` recognize different R executables.
Referring to this post: [Changing R versions for the RStudio Desktop IDE](https://support.rstudio.com/hc/en-us/articles/200486138-Changing-R-versions-for-the-RStudio-Desktop-IDE), we know that on Linux systems, `Rstudio` use the version of R pointed to by the output of `which R`. 

To override which version of R is used, we set `RSTUDIO_WHICH_R` environment variable to the R executable that we want to run against. For example, in terminal:
```
$ export RSTUDIO_WHICH_R=/opt/R/3.6.3/bin/R
```
And within the same terminal, launch Rstudio by typing:
```
$ rstudio
```

Because the `RSTUDIO_WHICH_R` is a temporary variable, it is only available in the activated shell instance. Calling `rstudio` in a new terminal will still point to the default R executable, which in our case is `/usr/local/bin/R`, which ,by default, points to `/opt/R/4.0.5/bin/R`.

Now that we can work with multiple R versions, it's time to build some R packages. Hopefully `cellassign` can be run properly this time.

`cellassign` depends on tensorflow which is another nasty built experience. I'll write about it next time.


Other useful resources:

[**Installing multiple versions of R on Linux**](https://support.rstudio.com/hc/en-us/articles/215488098-Installing-multiple-versions-of-R-on-Linux)*

[Using multiple versions of R with RStudio Workbench / RStudio Server Pro](https://support.rstudio.com/hc/en-us/articles/212364537-Using-multiple-versions-of-R-with-RStudio-Workbench-RStudio-Server-Pro)

[System Dependency Detection](https://docs.rstudio.com/rspm/admin/appendix/system-dependency-detection/)
