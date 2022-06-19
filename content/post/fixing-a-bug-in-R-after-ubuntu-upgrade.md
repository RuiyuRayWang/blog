---
title: "Fixing a Bug in R After Ubuntu Upgrade"
date: 2022-06-17T22:01:10+08:00
draft: false
mathjax: false
tags:        ["R"]
categories:  ["Coding" ]
---

Everybody knows the painstaking experience of system update, expecially when it comes to reconfiguring the environments and re-installing previously installed packages. Even with package management softwares like conda, bad things could still happen.

Recently I updated Ubuntu from 18.04 LTS to 20.04 LTS. At the same time I also decided to install the latest R 4.2.0 since there are some new features worth the bother.

I use `rig` to install R 4.2.0, and here comes the trouble.

```
(base) luolab@luolab-Z10PE-D16-WS:~$ rig add 4.2.0
[INFO] Running `sudo` for adding new R versions. This might need your password.
[INFO] Downloading https://cdn.rstudio.com/r/ubuntu-2004/pkgs/r-4.2.0_1_amd64.deb ->
    /tmp/rig/r-4.2.0_1_amd64.deb
[INFO] Running apt-get update
--nnn-- Start of apt-get output -------------------
Hit:1 https://dl.google.com/linux/chrome/deb stable InRelease
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease                
Hit:3 http://cn.archive.ubuntu.com/ubuntu focal InRelease                      
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:5 http://cn.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:6 http://security.ubuntu.com/ubuntu focal-security/main amd64 DEP-11 Metadata [40.7 kB]
Get:7 http://cn.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:8 http://security.ubuntu.com/ubuntu focal-security/universe amd64 DEP-11 Metadata [66.6 kB]
Get:9 http://cn.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1,924 kB]
Get:10 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 DEP-11 Metadata [2,464 B]
Get:11 http://cn.archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [678 kB]
Get:12 http://cn.archive.ubuntu.com/ubuntu focal-updates/main amd64 DEP-11 Metadata [278 kB]
Get:13 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [931 kB]
Get:14 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe i386 Packages [684 kB]
Get:15 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe amd64 DEP-11 Metadata [391 kB]
Get:16 http://cn.archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 DEP-11 Metadata [944 B]
Get:17 http://cn.archive.ubuntu.com/ubuntu focal-backports/main amd64 DEP-11 Metadata [7,992 B]
Get:18 http://cn.archive.ubuntu.com/ubuntu focal-backports/universe amd64 DEP-11 Metadata [30.5 kB]
Fetched 5,370 kB in 8s (668 kB/s)                                              
Reading package lists... Done
--uuu-- End of apt-get output ---------------------
[INFO] Running apt-get install
--nnn-- Start of apt-get output -------------------
Reading package lists... Done
Building dependency tree       
Reading state information... Done
gdebi-core is already the newest version (0.9.5.7+nmu3).
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
--uuu-- End of apt-get output ---------------------
[INFO] Running gdebi
--nnn-- Start of gdebi output ---------------------
Reading package lists... Done
Building dependency tree        
Reading state information... Done
Reading state information... Done
Selecting previously unselected package r-4.2.0.
(Reading database ... 276977 files and directories currently installed.)
Preparing to unpack /tmp/rig/r-4.2.0_1_amd64.deb ...
Unpacking r-4.2.0 (1) ...
Setting up r-4.2.0 (1) ...
--uuu-- End of gdebi output -----------------------
[INFO] Adding /usr/local/bin/R-4.2.0 -> /opt/R/4.2.0/bin/R
[INFO] Setting default CRAN mirror
[INFO] Setting up RSPM
[INFO] Setting up automatic system requirements installation.
[INFO] Installing pak for R 4.2.0 (if not installed yet)
/opt/R/4.2.0/bin/R: line 193: /usr/bin/sed: No such file or directory
ERROR: option '-e' requires a non-empty argument
[ERROR] Failed to run R 4.2.0 to install pak
```

 How come! The ubiquitous `sed` is missing!

 ```
(base) luolab@luolab-Z10PE-D16-WS:~$ which sed
/bin/sed
 ```

It turns out that `sed` is located at `/bin/sed` after Ubuntu upgrade whereas R still looks for it at `/usr/bin/sed`.
To fix that, we have to use `sudo` power.

```
(base) luolab@luolab-Z10PE-D16-WS:~$ sudo mv /bin/sed /usr/bin
```

In fact I've had the same error (cannot find utility in `/usr/bin` because it's located in `/bin`) with multiple package installations, such as `tar`.

The above method fix the issue just fine.
