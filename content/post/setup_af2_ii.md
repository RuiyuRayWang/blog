---
title: "Install Alphafold2 Docker Version (II)"
date: 2022-08-19T21:50:00+08:00
draft: false
mathjax: false
tags:        ["Machine Learning","Alphafold","Comp bio"]
categories:  ["Coding" ]
---

https://github.com/deepmind/alphafold

## Running AlphaFold

**The simplest way to run AlphaFold is using the provided Docker script.** This was tested on Google Cloud with a machine using the nvidia-gpu-cloud-image with 12 vCPUs, 85 GB of RAM, a 100 GB boot disk, the databases on an additional 3 TB disk, and an A100 GPU.

1. Clone this repository and `cd` into it.

```
(base) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO$ git clone https://github.com/deepmind/alphafold.git
Cloning into 'alphafold'...
remote: Enumerating objects: 569, done.
remote: Counting objects: 100% (220/220), done.
remote: Compressing objects: 100% (55/55), done.
remote: Total 569 (delta 177), reused 167 (delta 164), pack-reused 349
Receiving objects: 100% (569/569), 5.77 MiB | 26.00 KiB/s, done.
Resolving deltas: 100% (342/342), done.
(base) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO$ cd alphafold/
```

2. Build the Docker image:

```
(base) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ docker build -f docker/Dockerfile -t alphafold .
Sending build context to Docker daemon  13.36MB
Step 1/18 : ARG CUDA=11.1.1
Step 2/18 : FROM nvidia/cuda:${CUDA}-cudnn8-runtime-ubuntu18.04
11.1.1-cudnn8-runtime-ubuntu18.04: Pulling from nvidia/cuda
40dd5be53814: Pull complete 
b6f8396e6f3c: Pull complete 
3c444d3bc7b1: Pull complete 
4b27d231d2cd: Pull complete 
035911917ab7: Pull complete 
d2cd37fe954b: Pull complete 
6f16144b6364: Pull complete 
ddab44155817: Pull complete 
Digest: sha256:996e500db01edfaa1c87f5772b367896e1b87dba556279756b086250be2c1ae1
Status: Downloaded newer image for nvidia/cuda:11.1.1-cudnn8-runtime-ubuntu18.04
 ---> a6b5e71b6a39
Step 3/18 : ARG CUDA
 ---> Running in 3045c3475d2f
Removing intermediate container 3045c3475d2f
 ---> a7e2aecccd6e
Step 4/18 : SHELL ["/bin/bash", "-c"]
 ---> Running in debbf0845855
Removing intermediate container debbf0845855
 ---> 653d7c438d50
Step 5/18 : RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y         build-essential         cmake         cuda-command-line-tools-$(cut -f1,2 -d- <<< ${CUDA//./-})         git         hmmer         kalign         tzdata         wget     && rm -rf /var/lib/apt/lists/*
 ---> Running in 0edc9dc291c4
Get:1 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  InRelease [1581 B]
Get:2 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  Packages [910 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic InRelease [242 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://security.ubuntu.com/ubuntu bionic-security/restricted amd64 Packages [1100 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/universe amd64 Packages [11.3 MB]
Get:9 http://security.ubuntu.com/ubuntu bionic-security/universe amd64 Packages [1533 kB]
Get:10 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages [2937 kB]
Get:11 http://security.ubuntu.com/ubuntu bionic-security/multiverse amd64 Packages [22.8 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/multiverse amd64 Packages [186 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages [1344 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic/restricted amd64 Packages [13.5 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic-updates/universe amd64 Packages [2311 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic-updates/multiverse amd64 Packages [29.9 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic-updates/restricted amd64 Packages [1141 kB]
Get:18 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages [3369 kB]
Get:19 http://archive.ubuntu.com/ubuntu bionic-backports/universe amd64 Packages [12.9 kB]
Get:20 http://archive.ubuntu.com/ubuntu bionic-backports/main amd64 Packages [12.2 kB]
Fetched 26.8 MB in 15s (1821 kB/s)
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu cmake-data cpp cpp-7
  cuda-cudart-dev-11-1 cuda-cuobjdump-11-1 cuda-cupti-11-1 cuda-cupti-dev-11-1
  cuda-driver-dev-11-1 cuda-gdb-11-1 cuda-memcheck-11-1 cuda-nvcc-11-1
  cuda-nvdisasm-11-1 cuda-nvprof-11-1 cuda-sanitizer-11-1 dpkg-dev fakeroot
  g++ g++-7 gcc gcc-7 gcc-7-base git-man krb5-locales less
  libalgorithm-diff-perl libalgorithm-diff-xs-perl libalgorithm-merge-perl
  libarchive13 libasan4 libatomic1 libbinutils libbsd0 libc-dev-bin libc6
  libc6-dev libcc1-0 libcilkrts5 libcurl3-gnutls libcurl4 libdivsufsort3
  libdpkg-perl libedit2 liberror-perl libexpat1 libfakeroot
  libfile-fcntllock-perl libgcc-7-dev libgdbm-compat4 libgdbm5 libgomp1
  libgssapi-krb5-2 libicu60 libisl19 libitm1 libjsoncpp1 libk5crypto3
  libkeyutils1 libkrb5-3 libkrb5support0 liblocale-gettext-perl liblsan0
  liblzo2-2 libmpc3 libmpfr6 libmpx2 libnghttp2-14 libperl5.26 libpsl5
  libquadmath0 librhash0 librtmp1 libssl1.0.0 libstdc++-7-dev libtsan0
  libubsan0 libuv1 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6
  libxml2 libxmuu1 linux-libc-dev make manpages manpages-dev multiarch-support
  netbase openssh-client patch perl perl-modules-5.26 publicsuffix xauth
  xz-utils
Suggested packages:
  binutils-doc cmake-doc ninja-build cpp-doc gcc-7-locales debian-keyring
  g++-multilib g++-7-multilib gcc-7-doc libstdc++6-7-dbg gcc-multilib autoconf
  automake libtool flex bison gdb gcc-doc gcc-7-multilib libgcc1-dbg
  libgomp1-dbg libitm1-dbg libatomic1-dbg libasan4-dbg liblsan0-dbg
  libtsan0-dbg libubsan0-dbg libcilkrts5-dbg libmpx2-dbg libquadmath0-dbg
  gettext-base git-daemon-run | git-daemon-sysvinit git-doc git-el git-email
  git-gui gitk gitweb git-cvs git-mediawiki git-svn hmmer-doc lrzip glibc-doc
  locales bzr gdbm-l10n krb5-doc krb5-user libstdc++-7-doc make-doc
  man-browser keychain libpam-ssh monkeysphere ssh-askpass ed diffutils-doc
  perl-doc libterm-readline-gnu-perl | libterm-readline-perl-perl
The following NEW packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu build-essential cmake
  cmake-data cpp cpp-7 cuda-command-line-tools-11-1 cuda-cudart-dev-11-1
  cuda-cuobjdump-11-1 cuda-cupti-11-1 cuda-cupti-dev-11-1 cuda-driver-dev-11-1
  cuda-gdb-11-1 cuda-memcheck-11-1 cuda-nvcc-11-1 cuda-nvdisasm-11-1
  cuda-nvprof-11-1 cuda-sanitizer-11-1 dpkg-dev fakeroot g++ g++-7 gcc gcc-7
  gcc-7-base git git-man hmmer kalign krb5-locales less libalgorithm-diff-perl
  libalgorithm-diff-xs-perl libalgorithm-merge-perl libarchive13 libasan4
  libatomic1 libbinutils libbsd0 libc-dev-bin libc6-dev libcc1-0 libcilkrts5
  libcurl3-gnutls libcurl4 libdivsufsort3 libdpkg-perl libedit2 liberror-perl
  libexpat1 libfakeroot libfile-fcntllock-perl libgcc-7-dev libgdbm-compat4
  libgdbm5 libgomp1 libgssapi-krb5-2 libicu60 libisl19 libitm1 libjsoncpp1
  libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblocale-gettext-perl
  liblsan0 liblzo2-2 libmpc3 libmpfr6 libmpx2 libnghttp2-14 libperl5.26
  libpsl5 libquadmath0 librhash0 librtmp1 libssl1.0.0 libstdc++-7-dev libtsan0
  libubsan0 libuv1 libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6
  libxml2 libxmuu1 linux-libc-dev make manpages manpages-dev multiarch-support
  netbase openssh-client patch perl perl-modules-5.26 publicsuffix tzdata wget
  xauth xz-utils
The following packages will be upgraded:
  libc6
1 upgraded, 107 newly installed, 0 to remove and 28 not upgraded.
Need to get 166 MB of archives.
After this operation, 599 MB of additional disk space will be used.
Get:1 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-driver-dev-11-1 11.1.74-1 [25.4 kB]
Get:2 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-cudart-dev-11-1 11.1.74-1 [1734 kB]
Get:3 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-nvcc-11-1 11.1.105-1 [27.0 MB]
Get:4 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libc6 amd64 2.27-3ubuntu1.6 [2831 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 liblocale-gettext-perl amd64 1.07-3build2 [16.6 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 multiarch-support amd64 2.27-3ubuntu1.6 [6960 B]
Get:7 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libxau6 amd64 1:1.0.8-1ubuntu1 [7556 B]
Get:8 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libbsd0 amd64 0.8.7-1ubuntu0.1 [41.6 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 libxdmcp6 amd64 1:1.1.2-3 [10.7 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libxcb1 amd64 1.13-2~ubuntu18.04 [45.5 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libx11-data all 2:1.6.4-3ubuntu0.4 [114 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libx11-6 amd64 2:1.6.4-3ubuntu0.4 [572 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libxext6 amd64 2:1.3.3-1 [29.4 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic/main amd64 liblzo2-2 amd64 2.08-1.2 [48.7 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 perl-modules-5.26 all 5.26.1-6ubuntu0.5 [2762 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic/main amd64 libgdbm5 amd64 1.14.1-6 [26.0 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic/main amd64 libgdbm-compat4 amd64 1.14.1-6 [6084 B]
Get:18 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libperl5.26 amd64 5.26.1-6ubuntu0.5 [3534 kB]
Get:19 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 perl amd64 5.26.1-6ubuntu0.5 [201 kB]
Get:20 http://archive.ubuntu.com/ubuntu bionic/main amd64 less amd64 487-0.1 [112 kB]
Get:21 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libexpat1 amd64 2.2.5-3ubuntu0.7 [82.6 kB]
Get:22 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libicu60 amd64 60.2-3ubuntu3.2 [8050 kB]
Get:23 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libxml2 amd64 2.9.4+dfsg1-6.1ubuntu1.7 [663 kB]
Get:24 http://archive.ubuntu.com/ubuntu bionic/main amd64 netbase all 5.4 [12.7 kB]
Get:25 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 tzdata all 2022a-0ubuntu0.18.04 [190 kB]
Get:26 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 xz-utils amd64 5.2.2-1.3ubuntu0.1 [83.8 kB]
Get:27 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 krb5-locales all 1.16-2ubuntu0.2 [13.4 kB]
Get:28 http://archive.ubuntu.com/ubuntu bionic/main amd64 libedit2 amd64 3.1-20170329-1 [76.9 kB]
Get:29 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libkrb5support0 amd64 1.16-2ubuntu0.2 [30.8 kB]
Get:30 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libk5crypto3 amd64 1.16-2ubuntu0.2 [85.5 kB]
Get:31 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libkeyutils1 amd64 1.5.9-9.2ubuntu2.1 [8764 B]
Get:32 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libkrb5-3 amd64 1.16-2ubuntu0.2 [279 kB]
Get:33 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libgssapi-krb5-2 amd64 1.16-2ubuntu0.2 [122 kB]
Get:34 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpsl5 amd64 0.19.1-5build1 [41.8 kB]
Get:35 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libssl1.0.0 amd64 1.0.2n-1ubuntu5.10 [1089 kB]
Get:36 http://archive.ubuntu.com/ubuntu bionic/main amd64 libxmuu1 amd64 2:1.1.2-2 [9674 B]
Get:37 http://archive.ubuntu.com/ubuntu bionic/main amd64 manpages all 4.15-1 [1234 kB]
Get:38 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 openssh-client amd64 1:7.6p1-4ubuntu0.7 [610 kB]
Get:39 http://archive.ubuntu.com/ubuntu bionic/main amd64 publicsuffix all 20180223.1310-1 [97.6 kB]
Get:40 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 wget amd64 1.19.4-1ubuntu2.2 [316 kB]
Get:41 http://archive.ubuntu.com/ubuntu bionic/main amd64 xauth amd64 1:1.0.10-1 [24.6 kB]
Get:42 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 binutils-common amd64 2.30-21ubuntu1~18.04.7 [197 kB]
Get:43 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libbinutils amd64 2.30-21ubuntu1~18.04.7 [489 kB]
Get:44 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 binutils-x86-64-linux-gnu amd64 2.30-21ubuntu1~18.04.7 [1839 kB]
Get:45 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 binutils amd64 2.30-21ubuntu1~18.04.7 [3388 B]
Get:46 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libc-dev-bin amd64 2.27-3ubuntu1.6 [71.9 kB]
Get:47 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 linux-libc-dev amd64 4.15.0-191.202 [984 kB]
Get:48 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libc6-dev amd64 2.27-3ubuntu1.6 [2587 kB]
Get:49 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 gcc-7-base amd64 7.5.0-3ubuntu1~18.04 [18.3 kB]
Get:50 http://archive.ubuntu.com/ubuntu bionic/main amd64 libisl19 amd64 0.19-1 [551 kB]
Get:51 http://archive.ubuntu.com/ubuntu bionic/main amd64 libmpfr6 amd64 4.0.1-1 [243 kB]
Get:52 http://archive.ubuntu.com/ubuntu bionic/main amd64 libmpc3 amd64 1.1.0-1 [40.8 kB]
Get:53 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 cpp-7 amd64 7.5.0-3ubuntu1~18.04 [8591 kB]
Get:54 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 cpp amd64 4:7.4.0-1ubuntu2.3 [27.7 kB]
Get:55 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcc1-0 amd64 8.4.0-1ubuntu1~18.04 [39.4 kB]
Get:56 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libgomp1 amd64 8.4.0-1ubuntu1~18.04 [76.5 kB]
Get:57 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libitm1 amd64 8.4.0-1ubuntu1~18.04 [27.9 kB]
Get:58 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libatomic1 amd64 8.4.0-1ubuntu1~18.04 [9192 B]
Get:59 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libasan4 amd64 7.5.0-3ubuntu1~18.04 [358 kB]
Get:60 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 liblsan0 amd64 8.4.0-1ubuntu1~18.04 [133 kB]
Get:61 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libtsan0 amd64 8.4.0-1ubuntu1~18.04 [288 kB]
Get:62 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libubsan0 amd64 7.5.0-3ubuntu1~18.04 [126 kB]
Get:63 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcilkrts5 amd64 7.5.0-3ubuntu1~18.04 [42.5 kB]
Get:64 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libmpx2 amd64 8.4.0-1ubuntu1~18.04 [11.6 kB]
Get:65 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libquadmath0 amd64 8.4.0-1ubuntu1~18.04 [134 kB]
Get:66 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libgcc-7-dev amd64 7.5.0-3ubuntu1~18.04 [2378 kB]
Get:67 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 gcc-7 amd64 7.5.0-3ubuntu1~18.04 [9381 kB]
Get:68 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 gcc amd64 4:7.4.0-1ubuntu2.3 [5184 B]
Get:69 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libstdc++-7-dev amd64 7.5.0-3ubuntu1~18.04 [1471 kB]
Get:70 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 g++-7 amd64 7.5.0-3ubuntu1~18.04 [9697 kB]
Get:71 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 g++ amd64 4:7.4.0-1ubuntu2.3 [1568 B]
Get:72 http://archive.ubuntu.com/ubuntu bionic/main amd64 make amd64 4.1-9.1ubuntu1 [154 kB]
Get:73 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libdpkg-perl all 1.19.0.5ubuntu2.4 [212 kB]
Get:74 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 patch amd64 2.7.6-2ubuntu1.1 [102 kB]
Get:75 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 dpkg-dev all 1.19.0.5ubuntu2.4 [607 kB]
Get:76 http://archive.ubuntu.com/ubuntu bionic/main amd64 build-essential amd64 12.4ubuntu1 [4758 B]
Get:77 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 cmake-data all 3.10.2-1ubuntu2.18.04.2 [1332 kB]
Get:78 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libarchive13 amd64 3.2.2-3.1ubuntu0.7 [288 kB]
Get:79 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnghttp2-14 amd64 1.30.0-1ubuntu1 [77.8 kB]
Get:80 http://archive.ubuntu.com/ubuntu bionic/main amd64 librtmp1 amd64 2.4+20151223.gitfa8646d.1-1 [54.2 kB]
Get:81 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcurl4 amd64 7.58.0-2ubuntu3.19 [220 kB]
Get:82 http://archive.ubuntu.com/ubuntu bionic/main amd64 libjsoncpp1 amd64 1.7.4-3 [73.6 kB]
Get:83 http://archive.ubuntu.com/ubuntu bionic/main amd64 librhash0 amd64 1.3.6-2 [78.1 kB]
Get:84 http://archive.ubuntu.com/ubuntu bionic/main amd64 libuv1 amd64 1.18.0-3 [64.4 kB]
Get:85 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 cmake amd64 3.10.2-1ubuntu2.18.04.2 [3152 kB]
Get:86 http://archive.ubuntu.com/ubuntu bionic/main amd64 libfakeroot amd64 1.22-2ubuntu1 [25.9 kB]
Get:87 http://archive.ubuntu.com/ubuntu bionic/main amd64 fakeroot amd64 1.22-2ubuntu1 [62.3 kB]
Get:88 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 libcurl3-gnutls amd64 7.58.0-2ubuntu3.19 [219 kB]
Get:89 http://archive.ubuntu.com/ubuntu bionic/main amd64 liberror-perl all 0.17025-1 [22.8 kB]
Get:90 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 git-man all 1:2.17.1-1ubuntu0.12 [804 kB]
Get:91 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 git amd64 1:2.17.1-1ubuntu0.12 [3930 kB]
Get:92 http://archive.ubuntu.com/ubuntu bionic/universe amd64 kalign amd64 1:2.03+20110620-4 [103 kB]
Get:93 http://archive.ubuntu.com/ubuntu bionic/main amd64 libalgorithm-diff-perl all 1.19.03-1 [47.6 kB]
Get:94 http://archive.ubuntu.com/ubuntu bionic/main amd64 libalgorithm-diff-xs-perl amd64 0.04-5 [11.1 kB]
Get:95 http://archive.ubuntu.com/ubuntu bionic/main amd64 libalgorithm-merge-perl all 0.08-3 [12.0 kB]
Get:96 http://archive.ubuntu.com/ubuntu bionic/universe amd64 libdivsufsort3 amd64 2.0.1-3 [44.4 kB]
Get:97 http://archive.ubuntu.com/ubuntu bionic/main amd64 libfile-fcntllock-perl amd64 0.22-3build2 [33.2 kB]
Get:98 http://archive.ubuntu.com/ubuntu bionic/main amd64 manpages-dev all 4.15-1 [2217 kB]
Get:99 http://archive.ubuntu.com/ubuntu bionic/universe amd64 hmmer amd64 3.1b2+dfsg-5ubuntu1 [1119 kB]
Get:100 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-cupti-11-1 11.1.105-1 [10.9 MB]
Get:101 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-cupti-dev-11-1 11.1.105-1 [2294 kB]
Get:102 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-nvdisasm-11-1 11.1.74-1 [32.8 MB]
Get:103 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-cuobjdump-11-1 11.1.74-1 [110 kB]
Get:104 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-gdb-11-1 11.1.105-1 [3627 kB]
Get:105 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-memcheck-11-1 11.1.105-1 [144 kB]
Get:106 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-nvprof-11-1 11.1.105-1 [1910 kB]
Get:107 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-sanitizer-11-1 11.1.105-1 [7253 kB]
Get:108 https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64  cuda-command-line-tools-11-1 11.1.1-1 [2472 B]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 166 MB in 1min 29s (1868 kB/s)
(Reading database ... 4832 files and directories currently installed.)
Preparing to unpack .../libc6_2.27-3ubuntu1.6_amd64.deb ...
Unpacking libc6:amd64 (2.27-3ubuntu1.6) over (2.27-3ubuntu1.5) ...
Setting up libc6:amd64 (2.27-3ubuntu1.6) ...
Selecting previously unselected package liblocale-gettext-perl.
(Reading database ... 4832 files and directories currently installed.)
Preparing to unpack .../0-liblocale-gettext-perl_1.07-3build2_amd64.deb ...
Unpacking liblocale-gettext-perl (1.07-3build2) ...
Selecting previously unselected package multiarch-support.
Preparing to unpack .../1-multiarch-support_2.27-3ubuntu1.6_amd64.deb ...
Unpacking multiarch-support (2.27-3ubuntu1.6) ...
Selecting previously unselected package libxau6:amd64.
Preparing to unpack .../2-libxau6_1%3a1.0.8-1ubuntu1_amd64.deb ...
Unpacking libxau6:amd64 (1:1.0.8-1ubuntu1) ...
Selecting previously unselected package libbsd0:amd64.
Preparing to unpack .../3-libbsd0_0.8.7-1ubuntu0.1_amd64.deb ...
Unpacking libbsd0:amd64 (0.8.7-1ubuntu0.1) ...
Selecting previously unselected package libxdmcp6:amd64.
Preparing to unpack .../4-libxdmcp6_1%3a1.1.2-3_amd64.deb ...
Unpacking libxdmcp6:amd64 (1:1.1.2-3) ...
Selecting previously unselected package libxcb1:amd64.
Preparing to unpack .../5-libxcb1_1.13-2~ubuntu18.04_amd64.deb ...
Unpacking libxcb1:amd64 (1.13-2~ubuntu18.04) ...
Selecting previously unselected package libx11-data.
Preparing to unpack .../6-libx11-data_2%3a1.6.4-3ubuntu0.4_all.deb ...
Unpacking libx11-data (2:1.6.4-3ubuntu0.4) ...
Selecting previously unselected package libx11-6:amd64.
Preparing to unpack .../7-libx11-6_2%3a1.6.4-3ubuntu0.4_amd64.deb ...
Unpacking libx11-6:amd64 (2:1.6.4-3ubuntu0.4) ...
Setting up multiarch-support (2.27-3ubuntu1.6) ...
Selecting previously unselected package libxext6:amd64.
(Reading database ... 5136 files and directories currently installed.)
Preparing to unpack .../00-libxext6_2%3a1.3.3-1_amd64.deb ...
Unpacking libxext6:amd64 (2:1.3.3-1) ...
Selecting previously unselected package liblzo2-2:amd64.
Preparing to unpack .../01-liblzo2-2_2.08-1.2_amd64.deb ...
Unpacking liblzo2-2:amd64 (2.08-1.2) ...
Selecting previously unselected package perl-modules-5.26.
Preparing to unpack .../02-perl-modules-5.26_5.26.1-6ubuntu0.5_all.deb ...
Unpacking perl-modules-5.26 (5.26.1-6ubuntu0.5) ...
Selecting previously unselected package libgdbm5:amd64.
Preparing to unpack .../03-libgdbm5_1.14.1-6_amd64.deb ...
Unpacking libgdbm5:amd64 (1.14.1-6) ...
Selecting previously unselected package libgdbm-compat4:amd64.
Preparing to unpack .../04-libgdbm-compat4_1.14.1-6_amd64.deb ...
Unpacking libgdbm-compat4:amd64 (1.14.1-6) ...
Selecting previously unselected package libperl5.26:amd64.
Preparing to unpack .../05-libperl5.26_5.26.1-6ubuntu0.5_amd64.deb ...
Unpacking libperl5.26:amd64 (5.26.1-6ubuntu0.5) ...
Selecting previously unselected package perl.
Preparing to unpack .../06-perl_5.26.1-6ubuntu0.5_amd64.deb ...
Unpacking perl (5.26.1-6ubuntu0.5) ...
Selecting previously unselected package less.
Preparing to unpack .../07-less_487-0.1_amd64.deb ...
Unpacking less (487-0.1) ...
Selecting previously unselected package libexpat1:amd64.
Preparing to unpack .../08-libexpat1_2.2.5-3ubuntu0.7_amd64.deb ...
Unpacking libexpat1:amd64 (2.2.5-3ubuntu0.7) ...
Selecting previously unselected package libicu60:amd64.
Preparing to unpack .../09-libicu60_60.2-3ubuntu3.2_amd64.deb ...
Unpacking libicu60:amd64 (60.2-3ubuntu3.2) ...
Selecting previously unselected package libxml2:amd64.
Preparing to unpack .../10-libxml2_2.9.4+dfsg1-6.1ubuntu1.7_amd64.deb ...
Unpacking libxml2:amd64 (2.9.4+dfsg1-6.1ubuntu1.7) ...
Selecting previously unselected package netbase.
Preparing to unpack .../11-netbase_5.4_all.deb ...
Unpacking netbase (5.4) ...
Selecting previously unselected package tzdata.
Preparing to unpack .../12-tzdata_2022a-0ubuntu0.18.04_all.deb ...
Unpacking tzdata (2022a-0ubuntu0.18.04) ...
Selecting previously unselected package xz-utils.
Preparing to unpack .../13-xz-utils_5.2.2-1.3ubuntu0.1_amd64.deb ...
Unpacking xz-utils (5.2.2-1.3ubuntu0.1) ...
Selecting previously unselected package krb5-locales.
Preparing to unpack .../14-krb5-locales_1.16-2ubuntu0.2_all.deb ...
Unpacking krb5-locales (1.16-2ubuntu0.2) ...
Selecting previously unselected package libedit2:amd64.
Preparing to unpack .../15-libedit2_3.1-20170329-1_amd64.deb ...
Unpacking libedit2:amd64 (3.1-20170329-1) ...
Selecting previously unselected package libkrb5support0:amd64.
Preparing to unpack .../16-libkrb5support0_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libkrb5support0:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libk5crypto3:amd64.
Preparing to unpack .../17-libk5crypto3_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libk5crypto3:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libkeyutils1:amd64.
Preparing to unpack .../18-libkeyutils1_1.5.9-9.2ubuntu2.1_amd64.deb ...
Unpacking libkeyutils1:amd64 (1.5.9-9.2ubuntu2.1) ...
Selecting previously unselected package libkrb5-3:amd64.
Preparing to unpack .../19-libkrb5-3_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libkrb5-3:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libgssapi-krb5-2:amd64.
Preparing to unpack .../20-libgssapi-krb5-2_1.16-2ubuntu0.2_amd64.deb ...
Unpacking libgssapi-krb5-2:amd64 (1.16-2ubuntu0.2) ...
Selecting previously unselected package libpsl5:amd64.
Preparing to unpack .../21-libpsl5_0.19.1-5build1_amd64.deb ...
Unpacking libpsl5:amd64 (0.19.1-5build1) ...
Selecting previously unselected package libssl1.0.0:amd64.
Preparing to unpack .../22-libssl1.0.0_1.0.2n-1ubuntu5.10_amd64.deb ...
Unpacking libssl1.0.0:amd64 (1.0.2n-1ubuntu5.10) ...
Selecting previously unselected package libxmuu1:amd64.
Preparing to unpack .../23-libxmuu1_2%3a1.1.2-2_amd64.deb ...
Unpacking libxmuu1:amd64 (2:1.1.2-2) ...
Selecting previously unselected package manpages.
Preparing to unpack .../24-manpages_4.15-1_all.deb ...
Unpacking manpages (4.15-1) ...
Selecting previously unselected package openssh-client.
Preparing to unpack .../25-openssh-client_1%3a7.6p1-4ubuntu0.7_amd64.deb ...
Unpacking openssh-client (1:7.6p1-4ubuntu0.7) ...
Selecting previously unselected package publicsuffix.
Preparing to unpack .../26-publicsuffix_20180223.1310-1_all.deb ...
Unpacking publicsuffix (20180223.1310-1) ...
Selecting previously unselected package wget.
Preparing to unpack .../27-wget_1.19.4-1ubuntu2.2_amd64.deb ...
Unpacking wget (1.19.4-1ubuntu2.2) ...
Selecting previously unselected package xauth.
Preparing to unpack .../28-xauth_1%3a1.0.10-1_amd64.deb ...
Unpacking xauth (1:1.0.10-1) ...
Selecting previously unselected package binutils-common:amd64.
Preparing to unpack .../29-binutils-common_2.30-21ubuntu1~18.04.7_amd64.deb ...
Unpacking binutils-common:amd64 (2.30-21ubuntu1~18.04.7) ...
Selecting previously unselected package libbinutils:amd64.
Preparing to unpack .../30-libbinutils_2.30-21ubuntu1~18.04.7_amd64.deb ...
Unpacking libbinutils:amd64 (2.30-21ubuntu1~18.04.7) ...
Selecting previously unselected package binutils-x86-64-linux-gnu.
Preparing to unpack .../31-binutils-x86-64-linux-gnu_2.30-21ubuntu1~18.04.7_amd64.deb ...
Unpacking binutils-x86-64-linux-gnu (2.30-21ubuntu1~18.04.7) ...
Selecting previously unselected package binutils.
Preparing to unpack .../32-binutils_2.30-21ubuntu1~18.04.7_amd64.deb ...
Unpacking binutils (2.30-21ubuntu1~18.04.7) ...
Selecting previously unselected package libc-dev-bin.
Preparing to unpack .../33-libc-dev-bin_2.27-3ubuntu1.6_amd64.deb ...
Unpacking libc-dev-bin (2.27-3ubuntu1.6) ...
Selecting previously unselected package linux-libc-dev:amd64.
Preparing to unpack .../34-linux-libc-dev_4.15.0-191.202_amd64.deb ...
Unpacking linux-libc-dev:amd64 (4.15.0-191.202) ...
Selecting previously unselected package libc6-dev:amd64.
Preparing to unpack .../35-libc6-dev_2.27-3ubuntu1.6_amd64.deb ...
Unpacking libc6-dev:amd64 (2.27-3ubuntu1.6) ...
Selecting previously unselected package gcc-7-base:amd64.
Preparing to unpack .../36-gcc-7-base_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking gcc-7-base:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package libisl19:amd64.
Preparing to unpack .../37-libisl19_0.19-1_amd64.deb ...
Unpacking libisl19:amd64 (0.19-1) ...
Selecting previously unselected package libmpfr6:amd64.
Preparing to unpack .../38-libmpfr6_4.0.1-1_amd64.deb ...
Unpacking libmpfr6:amd64 (4.0.1-1) ...
Selecting previously unselected package libmpc3:amd64.
Preparing to unpack .../39-libmpc3_1.1.0-1_amd64.deb ...
Unpacking libmpc3:amd64 (1.1.0-1) ...
Selecting previously unselected package cpp-7.
Preparing to unpack .../40-cpp-7_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking cpp-7 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package cpp.
Preparing to unpack .../41-cpp_4%3a7.4.0-1ubuntu2.3_amd64.deb ...
Unpacking cpp (4:7.4.0-1ubuntu2.3) ...
Selecting previously unselected package libcc1-0:amd64.
Preparing to unpack .../42-libcc1-0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libcc1-0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libgomp1:amd64.
Preparing to unpack .../43-libgomp1_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libgomp1:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libitm1:amd64.
Preparing to unpack .../44-libitm1_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libitm1:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libatomic1:amd64.
Preparing to unpack .../45-libatomic1_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libatomic1:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libasan4:amd64.
Preparing to unpack .../46-libasan4_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libasan4:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package liblsan0:amd64.
Preparing to unpack .../47-liblsan0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking liblsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libtsan0:amd64.
Preparing to unpack .../48-libtsan0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libtsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libubsan0:amd64.
Preparing to unpack .../49-libubsan0_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libubsan0:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package libcilkrts5:amd64.
Preparing to unpack .../50-libcilkrts5_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libcilkrts5:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package libmpx2:amd64.
Preparing to unpack .../51-libmpx2_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libmpx2:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libquadmath0:amd64.
Preparing to unpack .../52-libquadmath0_8.4.0-1ubuntu1~18.04_amd64.deb ...
Unpacking libquadmath0:amd64 (8.4.0-1ubuntu1~18.04) ...
Selecting previously unselected package libgcc-7-dev:amd64.
Preparing to unpack .../53-libgcc-7-dev_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libgcc-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package gcc-7.
Preparing to unpack .../54-gcc-7_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking gcc-7 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package gcc.
Preparing to unpack .../55-gcc_4%3a7.4.0-1ubuntu2.3_amd64.deb ...
Unpacking gcc (4:7.4.0-1ubuntu2.3) ...
Selecting previously unselected package libstdc++-7-dev:amd64.
Preparing to unpack .../56-libstdc++-7-dev_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking libstdc++-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package g++-7.
Preparing to unpack .../57-g++-7_7.5.0-3ubuntu1~18.04_amd64.deb ...
Unpacking g++-7 (7.5.0-3ubuntu1~18.04) ...
Selecting previously unselected package g++.
Preparing to unpack .../58-g++_4%3a7.4.0-1ubuntu2.3_amd64.deb ...
Unpacking g++ (4:7.4.0-1ubuntu2.3) ...
Selecting previously unselected package make.
Preparing to unpack .../59-make_4.1-9.1ubuntu1_amd64.deb ...
Unpacking make (4.1-9.1ubuntu1) ...
Selecting previously unselected package libdpkg-perl.
Preparing to unpack .../60-libdpkg-perl_1.19.0.5ubuntu2.4_all.deb ...
Unpacking libdpkg-perl (1.19.0.5ubuntu2.4) ...
Selecting previously unselected package patch.
Preparing to unpack .../61-patch_2.7.6-2ubuntu1.1_amd64.deb ...
Unpacking patch (2.7.6-2ubuntu1.1) ...
Selecting previously unselected package dpkg-dev.
Preparing to unpack .../62-dpkg-dev_1.19.0.5ubuntu2.4_all.deb ...
Unpacking dpkg-dev (1.19.0.5ubuntu2.4) ...
Selecting previously unselected package build-essential.
Preparing to unpack .../63-build-essential_12.4ubuntu1_amd64.deb ...
Unpacking build-essential (12.4ubuntu1) ...
Selecting previously unselected package cmake-data.
Preparing to unpack .../64-cmake-data_3.10.2-1ubuntu2.18.04.2_all.deb ...
Unpacking cmake-data (3.10.2-1ubuntu2.18.04.2) ...
Selecting previously unselected package libarchive13:amd64.
Preparing to unpack .../65-libarchive13_3.2.2-3.1ubuntu0.7_amd64.deb ...
Unpacking libarchive13:amd64 (3.2.2-3.1ubuntu0.7) ...
Selecting previously unselected package libnghttp2-14:amd64.
Preparing to unpack .../66-libnghttp2-14_1.30.0-1ubuntu1_amd64.deb ...
Unpacking libnghttp2-14:amd64 (1.30.0-1ubuntu1) ...
Selecting previously unselected package librtmp1:amd64.
Preparing to unpack .../67-librtmp1_2.4+20151223.gitfa8646d.1-1_amd64.deb ...
Unpacking librtmp1:amd64 (2.4+20151223.gitfa8646d.1-1) ...
Selecting previously unselected package libcurl4:amd64.
Preparing to unpack .../68-libcurl4_7.58.0-2ubuntu3.19_amd64.deb ...
Unpacking libcurl4:amd64 (7.58.0-2ubuntu3.19) ...
Selecting previously unselected package libjsoncpp1:amd64.
Preparing to unpack .../69-libjsoncpp1_1.7.4-3_amd64.deb ...
Unpacking libjsoncpp1:amd64 (1.7.4-3) ...
Selecting previously unselected package librhash0:amd64.
Preparing to unpack .../70-librhash0_1.3.6-2_amd64.deb ...
Unpacking librhash0:amd64 (1.3.6-2) ...
Selecting previously unselected package libuv1:amd64.
Preparing to unpack .../71-libuv1_1.18.0-3_amd64.deb ...
Unpacking libuv1:amd64 (1.18.0-3) ...
Selecting previously unselected package cmake.
Preparing to unpack .../72-cmake_3.10.2-1ubuntu2.18.04.2_amd64.deb ...
Unpacking cmake (3.10.2-1ubuntu2.18.04.2) ...
Selecting previously unselected package cuda-driver-dev-11-1.
Preparing to unpack .../73-cuda-driver-dev-11-1_11.1.74-1_amd64.deb ...
Unpacking cuda-driver-dev-11-1 (11.1.74-1) ...
Selecting previously unselected package cuda-cudart-dev-11-1.
Preparing to unpack .../74-cuda-cudart-dev-11-1_11.1.74-1_amd64.deb ...
Unpacking cuda-cudart-dev-11-1 (11.1.74-1) ...
Selecting previously unselected package cuda-nvcc-11-1.
Preparing to unpack .../75-cuda-nvcc-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-nvcc-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-cupti-11-1.
Preparing to unpack .../76-cuda-cupti-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-cupti-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-cupti-dev-11-1.
Preparing to unpack .../77-cuda-cupti-dev-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-cupti-dev-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-nvdisasm-11-1.
Preparing to unpack .../78-cuda-nvdisasm-11-1_11.1.74-1_amd64.deb ...
Unpacking cuda-nvdisasm-11-1 (11.1.74-1) ...
Selecting previously unselected package cuda-cuobjdump-11-1.
Preparing to unpack .../79-cuda-cuobjdump-11-1_11.1.74-1_amd64.deb ...
Unpacking cuda-cuobjdump-11-1 (11.1.74-1) ...
Selecting previously unselected package cuda-gdb-11-1.
Preparing to unpack .../80-cuda-gdb-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-gdb-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-memcheck-11-1.
Preparing to unpack .../81-cuda-memcheck-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-memcheck-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-nvprof-11-1.
Preparing to unpack .../82-cuda-nvprof-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-nvprof-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-sanitizer-11-1.
Preparing to unpack .../83-cuda-sanitizer-11-1_11.1.105-1_amd64.deb ...
Unpacking cuda-sanitizer-11-1 (11.1.105-1) ...
Selecting previously unselected package cuda-command-line-tools-11-1.
Preparing to unpack .../84-cuda-command-line-tools-11-1_11.1.1-1_amd64.deb ...
Unpacking cuda-command-line-tools-11-1 (11.1.1-1) ...
Selecting previously unselected package libfakeroot:amd64.
Preparing to unpack .../85-libfakeroot_1.22-2ubuntu1_amd64.deb ...
Unpacking libfakeroot:amd64 (1.22-2ubuntu1) ...
Selecting previously unselected package fakeroot.
Preparing to unpack .../86-fakeroot_1.22-2ubuntu1_amd64.deb ...
Unpacking fakeroot (1.22-2ubuntu1) ...
Selecting previously unselected package libcurl3-gnutls:amd64.
Preparing to unpack .../87-libcurl3-gnutls_7.58.0-2ubuntu3.19_amd64.deb ...
Unpacking libcurl3-gnutls:amd64 (7.58.0-2ubuntu3.19) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../88-liberror-perl_0.17025-1_all.deb ...
Unpacking liberror-perl (0.17025-1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../89-git-man_1%3a2.17.1-1ubuntu0.12_all.deb ...
Unpacking git-man (1:2.17.1-1ubuntu0.12) ...
Selecting previously unselected package git.
Preparing to unpack .../90-git_1%3a2.17.1-1ubuntu0.12_amd64.deb ...
Unpacking git (1:2.17.1-1ubuntu0.12) ...
Selecting previously unselected package kalign.
Preparing to unpack .../91-kalign_1%3a2.03+20110620-4_amd64.deb ...
Unpacking kalign (1:2.03+20110620-4) ...
Selecting previously unselected package libalgorithm-diff-perl.
Preparing to unpack .../92-libalgorithm-diff-perl_1.19.03-1_all.deb ...
Unpacking libalgorithm-diff-perl (1.19.03-1) ...
Selecting previously unselected package libalgorithm-diff-xs-perl.
Preparing to unpack .../93-libalgorithm-diff-xs-perl_0.04-5_amd64.deb ...
Unpacking libalgorithm-diff-xs-perl (0.04-5) ...
Selecting previously unselected package libalgorithm-merge-perl.
Preparing to unpack .../94-libalgorithm-merge-perl_0.08-3_all.deb ...
Unpacking libalgorithm-merge-perl (0.08-3) ...
Selecting previously unselected package libdivsufsort3:amd64.
Preparing to unpack .../95-libdivsufsort3_2.0.1-3_amd64.deb ...
Unpacking libdivsufsort3:amd64 (2.0.1-3) ...
Selecting previously unselected package libfile-fcntllock-perl.
Preparing to unpack .../96-libfile-fcntllock-perl_0.22-3build2_amd64.deb ...
Unpacking libfile-fcntllock-perl (0.22-3build2) ...
Selecting previously unselected package manpages-dev.
Preparing to unpack .../97-manpages-dev_4.15-1_all.deb ...
Unpacking manpages-dev (4.15-1) ...
Selecting previously unselected package hmmer.
Preparing to unpack .../98-hmmer_3.1b2+dfsg-5ubuntu1_amd64.deb ...
Unpacking hmmer (3.1b2+dfsg-5ubuntu1) ...
Setting up libquadmath0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libedit2:amd64 (3.1-20170329-1) ...
Setting up libgomp1:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libatomic1:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up manpages (4.15-1) ...
Setting up kalign (1:2.03+20110620-4) ...
Setting up git-man (1:2.17.1-1ubuntu0.12) ...
Setting up libexpat1:amd64 (2.2.5-3ubuntu0.7) ...
Setting up libicu60:amd64 (60.2-3ubuntu3.2) ...
Setting up libcc1-0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up less (487-0.1) ...
Setting up make (4.1-9.1ubuntu1) ...
Setting up cuda-cuobjdump-11-1 (11.1.74-1) ...
Setting up libdivsufsort3:amd64 (2.0.1-3) ...
Setting up libssl1.0.0:amd64 (1.0.2n-1ubuntu5.10) ...
Setting up libnghttp2-14:amd64 (1.30.0-1ubuntu1) ...
Setting up libuv1:amd64 (1.18.0-3) ...
Setting up libpsl5:amd64 (0.19.1-5build1) ...
Setting up tzdata (2022a-0ubuntu0.18.04) ...

Current default time zone: 'Etc/UTC'
Local time is now:      Fri Aug 19 12:56:06 UTC 2022.
Universal Time is now:  Fri Aug 19 12:56:06 UTC 2022.
Run 'dpkg-reconfigure tzdata' if you wish to change it.

Setting up libtsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up linux-libc-dev:amd64 (4.15.0-191.202) ...
Setting up libmpfr6:amd64 (4.0.1-1) ...
Setting up cmake-data (3.10.2-1ubuntu2.18.04.2) ...
Setting up librtmp1:amd64 (2.4+20151223.gitfa8646d.1-1) ...
Setting up perl-modules-5.26 (5.26.1-6ubuntu0.5) ...
Setting up libgdbm5:amd64 (1.14.1-6) ...
Setting up libbsd0:amd64 (0.8.7-1ubuntu0.1) ...
Setting up libkrb5support0:amd64 (1.16-2ubuntu0.2) ...
Setting up libxml2:amd64 (2.9.4+dfsg1-6.1ubuntu1.7) ...
Setting up librhash0:amd64 (1.3.6-2) ...
Setting up liblsan0:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up gcc-7-base:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up binutils-common:amd64 (2.30-21ubuntu1~18.04.7) ...
Setting up cuda-sanitizer-11-1 (11.1.105-1) ...
Setting up libmpx2:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up hmmer (3.1b2+dfsg-5ubuntu1) ...
Setting up patch (2.7.6-2ubuntu1.1) ...
Setting up krb5-locales (1.16-2ubuntu0.2) ...
Setting up cuda-driver-dev-11-1 (11.1.74-1) ...
Setting up publicsuffix (20180223.1310-1) ...
Setting up cuda-memcheck-11-1 (11.1.105-1) ...
Setting up cuda-cudart-dev-11-1 (11.1.74-1) ...
Setting up xz-utils (5.2.2-1.3ubuntu0.1) ...
update-alternatives: using /usr/bin/xz to provide /usr/bin/lzma (lzma) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/lzma.1.gz because associated file /usr/share/man/man1/xz.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/unlzma.1.gz because associated file /usr/share/man/man1/unxz.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzcat.1.gz because associated file /usr/share/man/man1/xzcat.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzmore.1.gz because associated file /usr/share/man/man1/xzmore.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzless.1.gz because associated file /usr/share/man/man1/xzless.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzdiff.1.gz because associated file /usr/share/man/man1/xzdiff.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzcmp.1.gz because associated file /usr/share/man/man1/xzcmp.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzgrep.1.gz because associated file /usr/share/man/man1/xzgrep.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzegrep.1.gz because associated file /usr/share/man/man1/xzegrep.1.gz (of link group lzma) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/lzfgrep.1.gz because associated file /usr/share/man/man1/xzfgrep.1.gz (of link group lzma) doesn't exist
Setting up libfakeroot:amd64 (1.22-2ubuntu1) ...
Setting up wget (1.19.4-1ubuntu2.2) ...
Setting up liblocale-gettext-perl (1.07-3build2) ...
Setting up cuda-nvdisasm-11-1 (11.1.74-1) ...
Setting up libmpc3:amd64 (1.1.0-1) ...
Setting up libc-dev-bin (2.27-3ubuntu1.6) ...
Setting up libxdmcp6:amd64 (1:1.1.2-3) ...
Setting up libgdbm-compat4:amd64 (1.14.1-6) ...
Setting up libkeyutils1:amd64 (1.5.9-9.2ubuntu2.1) ...
Setting up cuda-nvprof-11-1 (11.1.105-1) ...
Setting up manpages-dev (4.15-1) ...
Setting up libc6-dev:amd64 (2.27-3ubuntu1.6) ...
Setting up libitm1:amd64 (8.4.0-1ubuntu1~18.04) ...
Setting up libx11-data (2:1.6.4-3ubuntu0.4) ...
Setting up libxau6:amd64 (1:1.0.8-1ubuntu1) ...
Setting up liblzo2-2:amd64 (2.08-1.2) ...
Setting up netbase (5.4) ...
Setting up libisl19:amd64 (0.19-1) ...
Setting up libjsoncpp1:amd64 (1.7.4-3) ...
Setting up libk5crypto3:amd64 (1.16-2ubuntu0.2) ...
Setting up libasan4:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libbinutils:amd64 (2.30-21ubuntu1~18.04.7) ...
Setting up libarchive13:amd64 (3.2.2-3.1ubuntu0.7) ...
Setting up libcilkrts5:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libubsan0:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up cuda-gdb-11-1 (11.1.105-1) ...
Setting up fakeroot (1.22-2ubuntu1) ...
update-alternatives: using /usr/bin/fakeroot-sysv to provide /usr/bin/fakeroot (fakeroot) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/fakeroot.1.gz because associated file /usr/share/man/man1/fakeroot-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/man1/faked.1.gz because associated file /usr/share/man/man1/faked-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/es/man1/fakeroot.1.gz because associated file /usr/share/man/es/man1/fakeroot-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/es/man1/faked.1.gz because associated file /usr/share/man/es/man1/faked-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/fr/man1/fakeroot.1.gz because associated file /usr/share/man/fr/man1/fakeroot-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/fr/man1/faked.1.gz because associated file /usr/share/man/fr/man1/faked-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/sv/man1/fakeroot.1.gz because associated file /usr/share/man/sv/man1/fakeroot-sysv.1.gz (of link group fakeroot) doesn't exist
update-alternatives: warning: skip creation of /usr/share/man/sv/man1/faked.1.gz because associated file /usr/share/man/sv/man1/faked-sysv.1.gz (of link group fakeroot) doesn't exist
Setting up libgcc-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up cpp-7 (7.5.0-3ubuntu1~18.04) ...
Setting up libstdc++-7-dev:amd64 (7.5.0-3ubuntu1~18.04) ...
Setting up libperl5.26:amd64 (5.26.1-6ubuntu0.5) ...
Setting up libkrb5-3:amd64 (1.16-2ubuntu0.2) ...
Setting up libxcb1:amd64 (1.13-2~ubuntu18.04) ...
Setting up binutils-x86-64-linux-gnu (2.30-21ubuntu1~18.04.7) ...
Setting up cpp (4:7.4.0-1ubuntu2.3) ...
Setting up libx11-6:amd64 (2:1.6.4-3ubuntu0.4) ...
Setting up libxmuu1:amd64 (2:1.1.2-2) ...
Setting up libgssapi-krb5-2:amd64 (1.16-2ubuntu0.2) ...
Setting up perl (5.26.1-6ubuntu0.5) ...
Setting up libfile-fcntllock-perl (0.22-3build2) ...
Setting up libalgorithm-diff-perl (1.19.03-1) ...
Setting up binutils (2.30-21ubuntu1~18.04.7) ...
Setting up openssh-client (1:7.6p1-4ubuntu0.7) ...
Setting up libxext6:amd64 (2:1.3.3-1) ...
Setting up gcc-7 (7.5.0-3ubuntu1~18.04) ...
Setting up liberror-perl (0.17025-1) ...
Setting up g++-7 (7.5.0-3ubuntu1~18.04) ...
Setting up libcurl3-gnutls:amd64 (7.58.0-2ubuntu3.19) ...
Setting up libcurl4:amd64 (7.58.0-2ubuntu3.19) ...
Setting up libdpkg-perl (1.19.0.5ubuntu2.4) ...
Setting up gcc (4:7.4.0-1ubuntu2.3) ...
Setting up xauth (1:1.0.10-1) ...
Setting up libalgorithm-merge-perl (0.08-3) ...
Setting up dpkg-dev (1.19.0.5ubuntu2.4) ...
Setting up libalgorithm-diff-xs-perl (0.04-5) ...
Setting up g++ (4:7.4.0-1ubuntu2.3) ...
update-alternatives: using /usr/bin/g++ to provide /usr/bin/c++ (c++) in auto mode
update-alternatives: warning: skip creation of /usr/share/man/man1/c++.1.gz because associated file /usr/share/man/man1/g++.1.gz (of link group c++) doesn't exist
Setting up cmake (3.10.2-1ubuntu2.18.04.2) ...
Setting up git (1:2.17.1-1ubuntu0.12) ...
Setting up build-essential (12.4ubuntu1) ...
Setting up cuda-nvcc-11-1 (11.1.105-1) ...
Setting up cuda-cupti-11-1 (11.1.105-1) ...
Setting up cuda-cupti-dev-11-1 (11.1.105-1) ...
Setting up cuda-command-line-tools-11-1 (11.1.1-1) ...
Processing triggers for libc-bin (2.27-3ubuntu1.5) ...
Removing intermediate container 0edc9dc291c4
 ---> 5435c388f720
Step 6/18 : RUN git clone --branch v3.3.0 https://github.com/soedinglab/hh-suite.git /tmp/hh-suite     && mkdir /tmp/hh-suite/build     && pushd /tmp/hh-suite/build     && cmake -DCMAKE_INSTALL_PREFIX=/opt/hhsuite ..     && make -j 4 && make install     && ln -s /opt/hhsuite/bin/* /usr/bin     && popd     && rm -rf /tmp/hh-suite
 ---> Running in 7d0f5549d48a
Cloning into '/tmp/hh-suite'...
Note: checking out '47a835a6329e8041741160c1196bc82d718d56e0'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by performing another checkout.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -b with the checkout command again. Example:

  git checkout -b <new-branch-name>

/tmp/hh-suite/build /
-- The C compiler identification is GNU 7.5.0
-- The CXX compiler identification is GNU 7.5.0
-- Check for working C compiler: /usr/bin/cc
-- Check for working C compiler: /usr/bin/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/bin/c++
-- Check for working CXX compiler: /usr/bin/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Compiler is GNU 
-- Looking for fmemopen
-- Looking for fmemopen - found
-- Could NOT find MPI_C (missing: MPI_C_LIB_NAMES MPI_C_HEADER_DIR MPI_C_WORKS) 
-- Could NOT find MPI_CXX (missing: MPI_CXX_LIB_NAMES MPI_CXX_HEADER_DIR MPI_CXX_WORKS) 
-- Could NOT find MPI (missing: MPI_C_FOUND MPI_CXX_FOUND) 
-- xxd not found, using xxdi.pl instead
-- Performing Test HAVE_AVX2_EXTENSIONS
-- Performing Test HAVE_AVX2_EXTENSIONS - Success
-- Performing Test HAVE_AVX_EXTENSIONS
-- Performing Test HAVE_AVX_EXTENSIONS - Success
-- Performing Test HAVE_SSE4_2_EXTENSIONS
-- Performing Test HAVE_SSE4_2_EXTENSIONS - Success
-- Performing Test HAVE_SSE4_1_EXTENSIONS
-- Performing Test HAVE_SSE4_1_EXTENSIONS - Success
-- Performing Test HAVE_SSE3_EXTENSIONS
-- Performing Test HAVE_SSE3_EXTENSIONS - Success
-- Performing Test HAVE_SSE2_EXTENSIONS
-- Performing Test HAVE_SSE2_EXTENSIONS - Success
-- Performing Test HAVE_SSE_EXTENSIONS
-- Performing Test HAVE_SSE_EXTENSIONS - Success
-- Found OpenMP_C: -fopenmp (found version "4.5") 
-- Found OpenMP_CXX: -fopenmp (found version "4.5") 
-- Found OpenMP: TRUE (found version "4.5")  
-- Found OpenMP
-- Configuring done
-- Generating done
-- Build files have been written to: /tmp/hh-suite/build
Scanning dependencies of target generated
Scanning dependencies of target ffindex
Scanning dependencies of target CS_OBJECTS
[  1%] Generating ../generated/context_data.crf.h
[  2%] Building C object lib/ffindex/src/CMakeFiles/ffindex.dir/ffindex.c.o
Scanning dependencies of target hhviterbialgorithm_with_celloff
[  3%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/aa.cc.o
[  4%] Building CXX object src/CMakeFiles/hhviterbialgorithm_with_celloff.dir/hhviterbialgorithm.cpp.o
[  5%] Building C object lib/ffindex/src/CMakeFiles/ffindex.dir/ffutil.c.o
[  6%] Linking C static library libffindex.a
[  6%] Built target ffindex
[  7%] Generating ../generated/context_data.lib.h
[  8%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/as.cc.o
[  9%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/assert_helpers.cc.o
[ 10%] Linking CXX static library libhhviterbialgorithm_with_celloff.a
[ 10%] Built target hhviterbialgorithm_with_celloff
[ 11%] Generating ../generated/cs219.lib.h
[ 12%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/blosum_matrix.cc.o
Scanning dependencies of target hhviterbialgorithm_and_ss
[ 13%] Building CXX object src/CMakeFiles/hhviterbialgorithm_and_ss.dir/hhviterbialgorithm.cpp.o
[ 14%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/getopt_pp.cc.o
[ 15%] Linking CXX static library libhhviterbialgorithm_and_ss.a
[ 15%] Built target hhviterbialgorithm_and_ss
Scanning dependencies of target hhviterbialgorithm_with_celloff_and_ss
[ 16%] Building CXX object src/CMakeFiles/hhviterbialgorithm_with_celloff_and_ss.dir/hhviterbialgorithm.cpp.o
[ 17%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/log.cc.o
[ 18%] Building CXX object src/cs/CMakeFiles/CS_OBJECTS.dir/application.cc.o
[ 19%] Linking CXX static library libhhviterbialgorithm_with_celloff_and_ss.a
[ 19%] Built target hhviterbialgorithm_with_celloff_and_ss
Scanning dependencies of target A3M_COMPRESS
[ 19%] Building CXX object src/CMakeFiles/A3M_COMPRESS.dir/a3m_compress.cpp.o
[ 20%] Linking CXX static library libCS_OBJECTS.a
[ 20%] Built target CS_OBJECTS
Scanning dependencies of target ffindex_reduce
[ 21%] Building C object lib/ffindex/src/CMakeFiles/ffindex_reduce.dir/ffindex_reduce.c.o
Scanning dependencies of target ffindex_build
[ 22%] Building C object lib/ffindex/src/CMakeFiles/ffindex_build.dir/ffindex_build.c.o
[ 23%] Linking C executable ffindex_reduce
[ 24%] Linking C executable ffindex_build
[ 24%] Built target ffindex_reduce
Scanning dependencies of target ffindex_get
[ 25%] Building C object lib/ffindex/src/CMakeFiles/ffindex_get.dir/ffindex_get.c.o
[ 25%] Built target ffindex_build
Scanning dependencies of target ffindex_from_fasta
[ 26%] Building C object lib/ffindex/src/CMakeFiles/ffindex_from_fasta.dir/ffindex_from_fasta.c.o
[ 27%] Linking C executable ffindex_get
[ 28%] Linking CXX static library libA3M_COMPRESS.a
[ 29%] Linking C executable ffindex_from_fasta
[ 29%] Built target ffindex_get
[ 29%] Built target ffindex_from_fasta
[ 29%] Built target A3M_COMPRESS
Scanning dependencies of target ffindex_modify
Scanning dependencies of target ffindex_from_fasta_with_split
[ 30%] Building C object lib/ffindex/src/CMakeFiles/ffindex_modify.dir/ffindex_modify.c.o
[ 31%] Building C object lib/ffindex/src/CMakeFiles/ffindex_from_fasta_with_split.dir/ffindex_from_fasta_with_split.c.o
Scanning dependencies of target ffindex_apply
[ 31%] Built target generated
[ 32%] Building C object lib/ffindex/src/CMakeFiles/ffindex_apply.dir/ffindex_apply_mpi.c.o
Scanning dependencies of target ffindex_unpack
[ 33%] Linking C executable ffindex_modify
[ 34%] Building C object lib/ffindex/src/CMakeFiles/ffindex_unpack.dir/ffindex_unpack.c.o
/tmp/hh-suite/lib/ffindex/src/ffindex_apply_mpi.c: In function 'ffindex_apply_by_entry':
/tmp/hh-suite/lib/ffindex/src/ffindex_apply_mpi.c:172:53: warning: format '%lld' expects argument of type 'long long int', but argument 6 has type 'int64_t {aka long int}' [-Wformat=]
             fprintf(log_file_out, "%s\t%ld\t%ld\t%lld\t%d\n", entry->name, entry->offset, entry->length, end - start, WEXITSTATUS(status));
                                                  ~~~^                                                    ~~~~~~~~~~~
                                                  %ld
[ 35%] Linking C executable ffindex_from_fasta_with_split
[ 35%] Built target ffindex_modify
Scanning dependencies of target ffindex_order
[ 36%] Linking C executable ffindex_unpack
[ 36%] Built target ffindex_from_fasta_with_split
[ 37%] Building C object lib/ffindex/src/CMakeFiles/ffindex_order.dir/ffindex_order.c.o
[ 38%] Linking C executable ffindex_apply
[ 38%] Built target ffindex_unpack
Scanning dependencies of target a3m_database_extract
[ 38%] Built target ffindex_apply
[ 39%] Linking C executable ffindex_order
[ 40%] Building CXX object src/CMakeFiles/a3m_database_extract.dir/a3m_database_extract.cpp.o
Scanning dependencies of target a3m_reduce
[ 41%] Building CXX object src/CMakeFiles/a3m_reduce.dir/a3m_reduce.cpp.o
[ 41%] Built target ffindex_order
Scanning dependencies of target a3m_extract
[ 42%] Building CXX object src/CMakeFiles/a3m_extract.dir/a3m_extract.cpp.o
Scanning dependencies of target HH_OBJECTS
[ 43%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhblits.cpp.o
[ 44%] Linking CXX executable a3m_reduce
[ 45%] Linking CXX executable a3m_database_extract
[ 46%] Linking CXX executable a3m_extract
[ 46%] Built target a3m_reduce
Scanning dependencies of target a3m_database_reduce
[ 46%] Built target a3m_database_extract
[ 47%] Building CXX object src/CMakeFiles/a3m_database_reduce.dir/a3m_database_reduce.cpp.o
[ 48%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhdecl.cpp.o
[ 48%] Built target a3m_extract
[ 49%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhhit.cpp.o
[ 50%] Linking CXX executable a3m_database_reduce
[ 50%] Built target a3m_database_reduce
Scanning dependencies of target a3m_database_filter
[ 51%] Building CXX object src/CMakeFiles/a3m_database_filter.dir/a3m_database_filter.cpp.o
[ 52%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhmatrices.cpp.o
[ 53%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhsearch.cpp.o
[ 54%] Linking CXX executable a3m_database_filter
[ 54%] Built target a3m_database_filter
[ 55%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhalign.cpp.o
[ 56%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhhitlist.cpp.o
[ 57%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhposteriordecoder.cpp.o
[ 58%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhutil.cpp.o
[ 59%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/util.cpp.o
[ 60%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhalignment.cpp.o
[ 61%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhforwardalgorithm.cpp.o
[ 62%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhhmm.cpp.o
[ 63%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhposteriordecoderrunner.cpp.o
[ 64%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhviterbialgorithm.cpp.o
/tmp/hh-suite/src/hhalignment.cpp: In member function 'int Alignment::Filter2(char*, int, int, float, int, int, int, const float (*)[20])':
/tmp/hh-suite/src/hhalignment.cpp:1596:5: warning: '%s' directive writing up to 4095 bytes into a region of size 86 [-Wformat-overflow=]
 int Alignment::Filter2(char keep[], int coverage, int qid, float qsc,
     ^~~~~~~~~
In file included from /usr/include/stdio.h:862:0,
                 from /usr/include/c++/7/cstdio:42,
                 from /usr/include/c++/7/ext/string_conversions.h:43,
                 from /usr/include/c++/7/bits/basic_string.h:6361,
                 from /usr/include/c++/7/string:52,
                 from /usr/include/c++/7/bits/locale_classes.h:40,
                 from /usr/include/c++/7/bits/ios_base.h:41,
                 from /usr/include/c++/7/ios:42,
                 from /usr/include/c++/7/istream:38,
                 from /usr/include/c++/7/fstream:38,
                 from /tmp/hh-suite/src/hhalignment.h:6,
                 from /tmp/hh-suite/src/hhalignment.cpp:8:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:34:43: note: '__builtin___sprintf_chk' output between 47 and 4142 bytes into a destination of size 100
       __bos (__s), __fmt, __va_arg_pack ());
                                           ^
[ 65%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhfullalignment.cpp.o
[ 66%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhhmmsimd.cpp.o
[ 67%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhposteriormatrix.cpp.o
[ 68%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhviterbi.cpp.o
[ 69%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhbacktracemac.cpp.o
[ 70%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhmacalgorithm.cpp.o
[ 71%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhprefilter.cpp.o
[ 72%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhviterbimatrix.cpp.o
[ 73%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhbackwardalgorithm.cpp.o
[ 74%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/ffindexdatabase.cpp.o
[ 75%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhdatabase.cpp.o
[ 76%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhhalfalignment.cpp.o
[ 77%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhviterbirunner.cpp.o
[ 78%] Building CXX object src/CMakeFiles/HH_OBJECTS.dir/hhfunc.cpp.o
[ 79%] Linking CXX static library libHH_OBJECTS.a
[ 79%] Built target HH_OBJECTS
Scanning dependencies of target hhblits_ca3m
Scanning dependencies of target hhsearch_omp
Scanning dependencies of target hhalign_omp
Scanning dependencies of target hhblits_omp
[ 80%] Building CXX object src/CMakeFiles/hhsearch_omp.dir/hhblits_omp.cpp.o
[ 81%] Building CXX object src/CMakeFiles/hhblits_ca3m.dir/hhblits_ca3m.cpp.o
[ 82%] Building CXX object src/CMakeFiles/hhblits_omp.dir/hhblits_omp.cpp.o
[ 83%] Building CXX object src/CMakeFiles/hhalign_omp.dir/hhblits_omp.cpp.o
/tmp/hh-suite/src/hhblits_ca3m.cpp: In function 'int main(int, const char**)':
/tmp/hh-suite/src/hhblits_ca3m.cpp:80:5: warning: '.ffindex' directive output may be truncated writing 8 bytes into a region of size between 1 and 4096 [-Wformat-truncation=]
 int main(int argc, const char **argv) {
     ^~~~
In file included from /usr/include/stdio.h:862:0,
                 from /usr/include/c++/7/cstdio:42,
                 from /usr/include/c++/7/ext/string_conversions.h:43,
                 from /usr/include/c++/7/bits/basic_string.h:6361,
                 from /usr/include/c++/7/string:52,
                 from /usr/include/c++/7/bits/locale_classes.h:40,
                 from /usr/include/c++/7/bits/ios_base.h:41,
                 from /usr/include/c++/7/ios:42,
                 from /usr/include/c++/7/istream:38,
                 from /usr/include/c++/7/fstream:38,
                 from /tmp/hh-suite/src/hhblits.h:11,
                 from /tmp/hh-suite/src/hhblits_ca3m.cpp:8:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:65:44: note: '__builtin___snprintf_chk' output between 9 and 4104 bytes into a destination of size 4096
        __bos (__s), __fmt, __va_arg_pack ());
                                            ^
[ 84%] Linking CXX executable hhblits_ca3m
/tmp/hh-suite/src/hhblits_omp.cpp: In function 'int main(int, const char**)':
/tmp/hh-suite/src/hhblits_omp.cpp:80:5: warning: '.ffindex' directive output may be truncated writing 8 bytes into a region of size between 1 and 4096 [-Wformat-truncation=]
 int main(int argc, const char **argv) {
     ^~~~
In file included from /usr/include/stdio.h:862:0,
                 from /usr/include/c++/7/cstdio:42,
                 from /usr/include/c++/7/ext/string_conversions.h:43,
                 from /usr/include/c++/7/bits/basic_string.h:6361,
                 from /usr/include/c++/7/string:52,
                 from /usr/include/c++/7/bits/locale_classes.h:40,
                 from /usr/include/c++/7/bits/ios_base.h:41,
                 from /usr/include/c++/7/ios:42,
                 from /usr/include/c++/7/istream:38,
                 from /usr/include/c++/7/fstream:38,
                 from /tmp/hh-suite/src/hhblits.h:11,
                 from /tmp/hh-suite/src/hhsearch.h:34,
                 from /tmp/hh-suite/src/hhblits_omp.cpp:8:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:65:44: note: '__builtin___snprintf_chk' output between 9 and 4104 bytes into a destination of size 4096
        __bos (__s), __fmt, __va_arg_pack ());
                                            ^
/tmp/hh-suite/src/hhblits_omp.cpp: In function 'int main(int, const char**)':
/tmp/hh-suite/src/hhblits_omp.cpp:80:5: warning: '.ffindex' directive output may be truncated writing 8 bytes into a region of size between 1 and 4096 [-Wformat-truncation=]
 int main(int argc, const char **argv) {
     ^~~~
In file included from /usr/include/stdio.h:862:0,
                 from /usr/include/c++/7/cstdio:42,
                 from /usr/include/c++/7/ext/string_conversions.h:43,
                 from /usr/include/c++/7/bits/basic_string.h:6361,
                 from /usr/include/c++/7/string:52,
                 from /usr/include/c++/7/bits/locale_classes.h:40,
                 from /usr/include/c++/7/bits/ios_base.h:41,
                 from /usr/include/c++/7/ios:42,
                 from /usr/include/c++/7/istream:38,
                 from /usr/include/c++/7/fstream:38,
                 from /tmp/hh-suite/src/hhblits.h:11,
                 from /tmp/hh-suite/src/hhsearch.h:34,
                 from /tmp/hh-suite/src/hhblits_omp.cpp:8:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:65:44: note: '__builtin___snprintf_chk' output between 9 and 4104 bytes into a destination of size 4096
        __bos (__s), __fmt, __va_arg_pack ());
                                            ^
/tmp/hh-suite/src/hhblits_omp.cpp: In function 'int main(int, const char**)':
/tmp/hh-suite/src/hhblits_omp.cpp:80:5: warning: '.ffindex' directive output may be truncated writing 8 bytes into a region of size between 1 and 4096 [-Wformat-truncation=]
 int main(int argc, const char **argv) {
     ^~~~
In file included from /usr/include/stdio.h:862:0,
                 from /usr/include/c++/7/cstdio:42,
                 from /usr/include/c++/7/ext/string_conversions.h:43,
                 from /usr/include/c++/7/bits/basic_string.h:6361,
                 from /usr/include/c++/7/string:52,
                 from /usr/include/c++/7/bits/locale_classes.h:40,
                 from /usr/include/c++/7/bits/ios_base.h:41,
                 from /usr/include/c++/7/ios:42,
                 from /usr/include/c++/7/istream:38,
                 from /usr/include/c++/7/fstream:38,
                 from /tmp/hh-suite/src/hhblits.h:11,
                 from /tmp/hh-suite/src/hhsearch.h:34,
                 from /tmp/hh-suite/src/hhblits_omp.cpp:8:
/usr/include/x86_64-linux-gnu/bits/stdio2.h:65:44: note: '__builtin___snprintf_chk' output between 9 and 4104 bytes into a destination of size 4096
        __bos (__s), __fmt, __va_arg_pack ());
                                            ^
[ 85%] Linking CXX executable hhblits_omp
[ 86%] Linking CXX executable hhalign_omp
[ 87%] Linking CXX executable hhsearch_omp
[ 87%] Built target hhblits_ca3m
[ 87%] Built target hhalign_omp
[ 87%] Built target hhblits_omp
[ 87%] Built target hhsearch_omp
Scanning dependencies of target cstranslate
Scanning dependencies of target hhalign
[ 88%] Building CXX object src/CMakeFiles/cstranslate.dir/cs/cstranslate_app.cc.o
Scanning dependencies of target hhsearch
[ 89%] Building CXX object src/CMakeFiles/hhalign.dir/hhblits_app.cpp.o
Scanning dependencies of target hhblits
[ 90%] Building CXX object src/CMakeFiles/hhsearch.dir/hhblits_app.cpp.o
[ 91%] Building CXX object src/CMakeFiles/hhblits.dir/hhblits_app.cpp.o
[ 92%] Linking CXX executable hhblits
[ 93%] Linking CXX executable hhsearch
[ 94%] Linking CXX executable hhalign
[ 94%] Built target hhblits
Scanning dependencies of target hhmake
[ 94%] Built target hhsearch
[ 95%] Building CXX object src/CMakeFiles/hhmake.dir/hhmake.cpp.o
[ 95%] Built target hhalign
Scanning dependencies of target hhfilter
[ 96%] Building CXX object src/CMakeFiles/hhfilter.dir/hhfilter.cpp.o
Scanning dependencies of target hhconsensus
[ 97%] Building CXX object src/CMakeFiles/hhconsensus.dir/hhconsensus.cpp.o
[ 98%] Linking CXX executable hhmake
[ 99%] Linking CXX executable hhfilter
[100%] Linking CXX executable hhconsensus
[100%] Built target hhmake
[100%] Built target hhfilter
[100%] Built target hhconsensus
[100%] Linking CXX executable cstranslate
[100%] Built target cstranslate
[  3%] Built target ffindex
[  5%] Built target ffindex_reduce
[  7%] Built target ffindex_build
[  9%] Built target ffindex_get
[ 11%] Built target ffindex_from_fasta
[ 13%] Built target ffindex_apply
[ 15%] Built target ffindex_modify
[ 17%] Built target ffindex_from_fasta_with_split
[ 19%] Built target ffindex_unpack
[ 21%] Built target ffindex_order
[ 24%] Built target generated
[ 32%] Built target CS_OBJECTS
[ 34%] Built target hhviterbialgorithm_with_celloff
[ 36%] Built target hhviterbialgorithm_and_ss
[ 38%] Built target hhviterbialgorithm_with_celloff_and_ss
[ 68%] Built target HH_OBJECTS
[ 70%] Built target hhblits_ca3m
[ 72%] Built target hhalign_omp
[ 74%] Built target hhsearch_omp
[ 76%] Built target hhblits_omp
[ 77%] Built target A3M_COMPRESS
[ 78%] Built target cstranslate
[ 80%] Built target hhsearch
[ 82%] Built target hhalign
[ 84%] Built target hhblits
[ 86%] Built target hhmake
[ 88%] Built target hhfilter
[ 90%] Built target a3m_database_extract
[ 92%] Built target hhconsensus
[ 94%] Built target a3m_reduce
[ 96%] Built target a3m_extract
[ 98%] Built target a3m_database_reduce
[100%] Built target a3m_database_filter
Install the project...
-- Install configuration: "Release"
-- Installing: /opt/hhsuite/bin/ffindex_reduce
-- Installing: /opt/hhsuite/bin/ffindex_apply
-- Installing: /opt/hhsuite/bin/ffindex_build
-- Installing: /opt/hhsuite/bin/ffindex_from_fasta
-- Installing: /opt/hhsuite/bin/ffindex_get
-- Installing: /opt/hhsuite/bin/ffindex_modify
-- Installing: /opt/hhsuite/bin/ffindex_unpack
-- Installing: /opt/hhsuite/bin/ffindex_order
-- Installing: /opt/hhsuite/bin/ffindex_from_fasta_with_split
-- Installing: /opt/hhsuite/data/context_data.crf
-- Installing: /opt/hhsuite/data/context_data.lib
-- Installing: /opt/hhsuite/data/cs219.lib
-- Installing: /opt/hhsuite/data/do_not_delete
-- Installing: /opt/hhsuite/data/do_not_delete.phr
-- Installing: /opt/hhsuite/data/do_not_delete.pin
-- Installing: /opt/hhsuite/data/do_not_delete.psq
-- Installing: /opt/hhsuite/bin/hhblits
-- Installing: /opt/hhsuite/bin/hhmake
-- Installing: /opt/hhsuite/bin/hhfilter
-- Installing: /opt/hhsuite/bin/hhsearch
-- Installing: /opt/hhsuite/bin/hhalign
-- Installing: /opt/hhsuite/bin/hhconsensus
-- Installing: /opt/hhsuite/bin/a3m_extract
-- Installing: /opt/hhsuite/bin/a3m_reduce
-- Installing: /opt/hhsuite/bin/a3m_database_reduce
-- Installing: /opt/hhsuite/bin/a3m_database_extract
-- Installing: /opt/hhsuite/bin/a3m_database_filter
-- Installing: /opt/hhsuite/bin/cstranslate
-- Installing: /opt/hhsuite/bin/hhblits_omp
-- Installing: /opt/hhsuite/bin/hhsearch_omp
-- Installing: /opt/hhsuite/bin/hhalign_omp
-- Installing: /opt/hhsuite/bin/hhblits_ca3m
-- Installing: /opt/hhsuite/scripts/a3m.py
-- Installing: /opt/hhsuite/scripts/addss.pl
-- Installing: /opt/hhsuite/scripts/Align.pm
-- Installing: /opt/hhsuite/scripts/check_a3m.py
-- Installing: /opt/hhsuite/scripts/cif2fasta.py
-- Installing: /opt/hhsuite/scripts/create_profile_from_hhm.pl
-- Installing: /opt/hhsuite/scripts/create_profile_from_hmmer.pl
-- Installing: /opt/hhsuite/scripts/ffindex.py
-- Installing: /opt/hhsuite/scripts/get_a3m_size.py
-- Installing: /opt/hhsuite/scripts/hh_reader.py
-- Installing: /opt/hhsuite/scripts/hhmakemodel.pl
-- Installing: /opt/hhsuite/scripts/hhmakemodel.py
-- Installing: /opt/hhsuite/scripts/HHPaths.pm
-- Installing: /opt/hhsuite/scripts/hhsuitedb.py
-- Installing: /opt/hhsuite/scripts/mergeali.pl
-- Installing: /opt/hhsuite/scripts/multithread.pl
-- Installing: /opt/hhsuite/scripts/pdb2fasta.pl
-- Installing: /opt/hhsuite/scripts/pdbfilter.pl
-- Installing: /opt/hhsuite/scripts/pdbfilter.py
-- Installing: /opt/hhsuite/scripts/reformat.pl
-- Installing: /opt/hhsuite/scripts/renumberpdb.pl
-- Installing: /opt/hhsuite/scripts/splitfasta.pl
/
Removing intermediate container 7d0f5549d48a
 ---> 69f17acd3345
Step 7/18 : RUN wget -q -P /tmp   https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh     && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda     && rm /tmp/Miniconda3-latest-Linux-x86_64.sh
 ---> Running in 00cf5eeab640
PREFIX=/opt/conda
Unpacking payload ...
Collecting package metadata (current_repodata.json): ...working... done                                        
Solving environment: ...working... done

## Package Plan ##

  environment location: /opt/conda

  added / updated specs:
    - _libgcc_mutex==0.1=main
    - _openmp_mutex==4.5=1_gnu
    - brotlipy==0.7.0=py39h27cfd23_1003
    - ca-certificates==2022.3.29=h06a4308_1
    - certifi==2021.10.8=py39h06a4308_2
    - cffi==1.15.0=py39hd667e15_1
    - charset-normalizer==2.0.4=pyhd3eb1b0_0
    - colorama==0.4.4=pyhd3eb1b0_0
    - conda-content-trust==0.1.1=pyhd3eb1b0_0
    - conda-package-handling==1.8.1=py39h7f8727e_0
    - conda==4.12.0=py39h06a4308_0
    - cryptography==36.0.0=py39h9ce1e76_0
    - idna==3.3=pyhd3eb1b0_0
    - ld_impl_linux-64==2.35.1=h7274673_9
    - libffi==3.3=he6710b0_2
    - libgcc-ng==9.3.0=h5101ec6_17
    - libgomp==9.3.0=h5101ec6_17
    - libstdcxx-ng==9.3.0=hd4cf53a_17
    - ncurses==6.3=h7f8727e_2
    - openssl==1.1.1n=h7f8727e_0
    - pip==21.2.4=py39h06a4308_0
    - pycosat==0.6.3=py39h27cfd23_0
    - pycparser==2.21=pyhd3eb1b0_0
    - pyopenssl==22.0.0=pyhd3eb1b0_0
    - pysocks==1.7.1=py39h06a4308_0
    - python==3.9.12=h12debd9_0
    - readline==8.1.2=h7f8727e_1
    - requests==2.27.1=pyhd3eb1b0_0
    - ruamel_yaml==0.15.100=py39h27cfd23_0
    - setuptools==61.2.0=py39h06a4308_0
    - six==1.16.0=pyhd3eb1b0_1
    - sqlite==3.38.2=hc218d9a_0
    - tk==8.6.11=h1ccaba5_0
    - tqdm==4.63.0=pyhd3eb1b0_0
    - tzdata==2022a=hda174b7_0
    - urllib3==1.26.8=pyhd3eb1b0_0
    - wheel==0.37.1=pyhd3eb1b0_0
    - xz==5.2.5=h7b6447c_0
    - yaml==0.2.5=h7b6447c_0
    - zlib==1.2.12=h7f8727e_1


The following NEW packages will be INSTALLED:

  _libgcc_mutex      pkgs/main/linux-64::_libgcc_mutex-0.1-main
  _openmp_mutex      pkgs/main/linux-64::_openmp_mutex-4.5-1_gnu
  brotlipy           pkgs/main/linux-64::brotlipy-0.7.0-py39h27cfd23_1003
  ca-certificates    pkgs/main/linux-64::ca-certificates-2022.3.29-h06a4308_1
  certifi            pkgs/main/linux-64::certifi-2021.10.8-py39h06a4308_2
  cffi               pkgs/main/linux-64::cffi-1.15.0-py39hd667e15_1
  charset-normalizer pkgs/main/noarch::charset-normalizer-2.0.4-pyhd3eb1b0_0
  colorama           pkgs/main/noarch::colorama-0.4.4-pyhd3eb1b0_0
  conda              pkgs/main/linux-64::conda-4.12.0-py39h06a4308_0
  conda-content-tru~ pkgs/main/noarch::conda-content-trust-0.1.1-pyhd3eb1b0_0
  conda-package-han~ pkgs/main/linux-64::conda-package-handling-1.8.1-py39h7f8727e_0
  cryptography       pkgs/main/linux-64::cryptography-36.0.0-py39h9ce1e76_0
  idna               pkgs/main/noarch::idna-3.3-pyhd3eb1b0_0
  ld_impl_linux-64   pkgs/main/linux-64::ld_impl_linux-64-2.35.1-h7274673_9
  libffi             pkgs/main/linux-64::libffi-3.3-he6710b0_2
  libgcc-ng          pkgs/main/linux-64::libgcc-ng-9.3.0-h5101ec6_17
  libgomp            pkgs/main/linux-64::libgomp-9.3.0-h5101ec6_17
  libstdcxx-ng       pkgs/main/linux-64::libstdcxx-ng-9.3.0-hd4cf53a_17
  ncurses            pkgs/main/linux-64::ncurses-6.3-h7f8727e_2
  openssl            pkgs/main/linux-64::openssl-1.1.1n-h7f8727e_0
  pip                pkgs/main/linux-64::pip-21.2.4-py39h06a4308_0
  pycosat            pkgs/main/linux-64::pycosat-0.6.3-py39h27cfd23_0
  pycparser          pkgs/main/noarch::pycparser-2.21-pyhd3eb1b0_0
  pyopenssl          pkgs/main/noarch::pyopenssl-22.0.0-pyhd3eb1b0_0
  pysocks            pkgs/main/linux-64::pysocks-1.7.1-py39h06a4308_0
  python             pkgs/main/linux-64::python-3.9.12-h12debd9_0
  readline           pkgs/main/linux-64::readline-8.1.2-h7f8727e_1
  requests           pkgs/main/noarch::requests-2.27.1-pyhd3eb1b0_0
  ruamel_yaml        pkgs/main/linux-64::ruamel_yaml-0.15.100-py39h27cfd23_0
  setuptools         pkgs/main/linux-64::setuptools-61.2.0-py39h06a4308_0
  six                pkgs/main/noarch::six-1.16.0-pyhd3eb1b0_1
  sqlite             pkgs/main/linux-64::sqlite-3.38.2-hc218d9a_0
  tk                 pkgs/main/linux-64::tk-8.6.11-h1ccaba5_0
  tqdm               pkgs/main/noarch::tqdm-4.63.0-pyhd3eb1b0_0
  tzdata             pkgs/main/noarch::tzdata-2022a-hda174b7_0
  urllib3            pkgs/main/noarch::urllib3-1.26.8-pyhd3eb1b0_0
  wheel              pkgs/main/noarch::wheel-0.37.1-pyhd3eb1b0_0
  xz                 pkgs/main/linux-64::xz-5.2.5-h7b6447c_0
  yaml               pkgs/main/linux-64::yaml-0.2.5-h7b6447c_0
  zlib               pkgs/main/linux-64::zlib-1.2.12-h7f8727e_1


Preparing transaction: ...working... done
Executing transaction: ...working... done
installation finished.
Removing intermediate container 00cf5eeab640
 ---> 6da2c0e72429
Step 8/18 : ENV PATH="/opt/conda/bin:$PATH"
 ---> Running in 7c44adc6e4ac
Removing intermediate container 7c44adc6e4ac
 ---> 579e466e2f09
Step 9/18 : RUN conda update -qy conda     && conda install -y -c conda-forge       openmm=7.5.1       cudatoolkit==${CUDA_VERSION}       pdbfixer       pip       python=3.7
 ---> Running in b479fe3ee749
Collecting package metadata (current_repodata.json): ...working... done
Solving environment: ...working... done

## Package Plan ##

  environment location: /opt/conda

  added / updated specs:
    - conda


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    _openmp_mutex-5.1          |            1_gnu          21 KB
    ca-certificates-2022.07.19 |       h06a4308_0         124 KB
    certifi-2022.6.15          |   py39h06a4308_0         153 KB
    cffi-1.15.1                |   py39h74dc2b5_0         228 KB
    conda-4.13.0               |   py39h06a4308_0         895 KB
    cryptography-37.0.1        |   py39h9ce1e76_0         1.3 MB
    ld_impl_linux-64-2.38      |       h1181459_1         654 KB
    libgcc-ng-11.2.0           |       h1234567_1         5.3 MB
    libgomp-11.2.0             |       h1234567_1         474 KB
    libstdcxx-ng-11.2.0        |       h1234567_1         4.7 MB
    ncurses-6.3                |       h5eee18b_3         781 KB
    openssl-1.1.1q             |       h7f8727e_0         2.5 MB
    pip-22.1.2                 |   py39h06a4308_0         2.5 MB
    requests-2.28.1            |   py39h06a4308_0          92 KB
    sqlite-3.39.2              |       h5082296_0         1.1 MB
    tk-8.6.12                  |       h1ccaba5_0         3.0 MB
    tqdm-4.64.0                |   py39h06a4308_0         126 KB
    urllib3-1.26.11            |   py39h06a4308_0         182 KB
    xz-5.2.5                   |       h7f8727e_1         339 KB
    zlib-1.2.12                |       h7f8727e_2         106 KB
    ------------------------------------------------------------
                                           Total:        24.5 MB

The following packages will be REMOVED:

  colorama-0.4.4-pyhd3eb1b0_0
  conda-content-trust-0.1.1-pyhd3eb1b0_0
  six-1.16.0-pyhd3eb1b0_1

The following packages will be UPDATED:

  _openmp_mutex                                   4.5-1_gnu --> 5.1-1_gnu
  ca-certificates                      2022.3.29-h06a4308_1 --> 2022.07.19-h06a4308_0
  certifi                          2021.10.8-py39h06a4308_2 --> 2022.6.15-py39h06a4308_0
  cffi                                1.15.0-py39hd667e15_1 --> 1.15.1-py39h74dc2b5_0
  conda                               4.12.0-py39h06a4308_0 --> 4.13.0-py39h06a4308_0
  cryptography                        36.0.0-py39h9ce1e76_0 --> 37.0.1-py39h9ce1e76_0
  ld_impl_linux-64                        2.35.1-h7274673_9 --> 2.38-h1181459_1
  libgcc-ng                               9.3.0-h5101ec6_17 --> 11.2.0-h1234567_1
  libgomp                                 9.3.0-h5101ec6_17 --> 11.2.0-h1234567_1
  libstdcxx-ng                            9.3.0-hd4cf53a_17 --> 11.2.0-h1234567_1
  ncurses                                    6.3-h7f8727e_2 --> 6.3-h5eee18b_3
  openssl                                 1.1.1n-h7f8727e_0 --> 1.1.1q-h7f8727e_0
  pip                                 21.2.4-py39h06a4308_0 --> 22.1.2-py39h06a4308_0
  requests           pkgs/main/noarch::requests-2.27.1-pyh~ --> pkgs/main/linux-64::requests-2.28.1-py39h06a4308_0
  sqlite                                  3.38.2-hc218d9a_0 --> 3.39.2-h5082296_0
  tk                                      8.6.11-h1ccaba5_0 --> 8.6.12-h1ccaba5_0
  tqdm               pkgs/main/noarch::tqdm-4.63.0-pyhd3eb~ --> pkgs/main/linux-64::tqdm-4.64.0-py39h06a4308_0
  urllib3            pkgs/main/noarch::urllib3-1.26.8-pyhd~ --> pkgs/main/linux-64::urllib3-1.26.11-py39h06a4308_0
  xz                                       5.2.5-h7b6447c_0 --> 5.2.5-h7f8727e_1
  zlib                                    1.2.12-h7f8727e_1 --> 1.2.12-h7f8727e_2


Preparing transaction: ...working... done
Verifying transaction: ...working... done
Executing transaction: ...working... done
Collecting package metadata (current_repodata.json): ...working... done
Solving environment: ...working... failed with initial frozen solve. Retrying with flexible solve.
Solving environment: ...working... failed with repodata from current_repodata.json, will retry with next repodata source.
Collecting package metadata (repodata.json): ...working... done
Solving environment: ...working... done

## Package Plan ##

  environment location: /opt/conda

  added / updated specs:
    - cudatoolkit==11.1.1
    - openmm=7.5.1
    - pdbfixer
    - pip
    - python=3.7


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    ca-certificates-2022.6.15  |       ha878542_0         149 KB  conda-forge
    certifi-2022.6.15          |   py37h89c1867_0         155 KB  conda-forge
    cffi-1.14.6                |   py37hc58025e_0         225 KB  conda-forge
    colorama-0.4.5             |     pyhd8ed1ab_0          18 KB  conda-forge
    conda-4.14.0               |   py37h89c1867_0        1010 KB  conda-forge
    conda-package-handling-1.8.1|   py37h540881e_1         1.0 MB  conda-forge
    cryptography-37.0.2        |   py37h38fbfac_0         1.5 MB  conda-forge
    cudatoolkit-11.1.1         |      ha002fc5_10        1.20 GB  conda-forge
    fftw-3.3.10                |nompi_h77c792f_102         6.4 MB  conda-forge
    libblas-3.9.0              |15_linux64_openblas          12 KB  conda-forge
    libcblas-3.9.0             |15_linux64_openblas          12 KB  conda-forge
    libgfortran-ng-12.1.0      |      h69a702a_16          23 KB  conda-forge
    libgfortran5-12.1.0        |      hdcd56e2_16         1.8 MB  conda-forge
    liblapack-3.9.0            |15_linux64_openblas          12 KB  conda-forge
    libopenblas-0.3.20         |pthreads_h78a6416_0        10.1 MB  conda-forge
    numpy-1.21.6               |   py37h976b520_0         6.1 MB  conda-forge
    ocl-icd-2.3.1              |       h7f98852_0         119 KB  conda-forge
    ocl-icd-system-1.0.0       |                1           4 KB  conda-forge
    openmm-7.5.1               |   py37h729b507_1        10.7 MB  conda-forge
    openssl-1.1.1o             |       h166bdaf_0         2.1 MB  conda-forge
    pdbfixer-1.7               |     pyhd3deb0d_0         167 KB  conda-forge
    pip-22.2.2                 |     pyhd8ed1ab_0         1.5 MB  conda-forge
    pycosat-0.6.3              |py37h540881e_1010         107 KB  conda-forge
    pysocks-1.7.1              |   py37h89c1867_5          28 KB  conda-forge
    python-3.7.10              |hffdb5ce_100_cpython        57.3 MB  conda-forge
    python_abi-3.7             |          2_cp37m           4 KB  conda-forge
    requests-2.28.1            |     pyhd8ed1ab_0          53 KB  conda-forge
    ruamel_yaml-0.15.80        |py37h5e8e339_1006         270 KB  conda-forge
    setuptools-65.0.2          |   py37h89c1867_0         1.4 MB  conda-forge
    six-1.16.0                 |     pyh6c4a22f_0          14 KB  conda-forge
    toolz-0.12.0               |     pyhd8ed1ab_0          48 KB  conda-forge
    tqdm-4.64.0                |     pyhd8ed1ab_0          81 KB  conda-forge
    urllib3-1.25.8             |   py37hc8dfbb8_1         160 KB  conda-forge
    ------------------------------------------------------------
                                           Total:        1.30 GB

The following NEW packages will be INSTALLED:

  colorama           conda-forge/noarch::colorama-0.4.5-pyhd8ed1ab_0
  cudatoolkit        conda-forge/linux-64::cudatoolkit-11.1.1-ha002fc5_10
  fftw               conda-forge/linux-64::fftw-3.3.10-nompi_h77c792f_102
  libblas            conda-forge/linux-64::libblas-3.9.0-15_linux64_openblas
  libcblas           conda-forge/linux-64::libcblas-3.9.0-15_linux64_openblas
  libgfortran-ng     conda-forge/linux-64::libgfortran-ng-12.1.0-h69a702a_16
  libgfortran5       conda-forge/linux-64::libgfortran5-12.1.0-hdcd56e2_16
  liblapack          conda-forge/linux-64::liblapack-3.9.0-15_linux64_openblas
  libopenblas        conda-forge/linux-64::libopenblas-0.3.20-pthreads_h78a6416_0
  numpy              conda-forge/linux-64::numpy-1.21.6-py37h976b520_0
  ocl-icd            conda-forge/linux-64::ocl-icd-2.3.1-h7f98852_0
  ocl-icd-system     conda-forge/linux-64::ocl-icd-system-1.0.0-1
  openmm             conda-forge/linux-64::openmm-7.5.1-py37h729b507_1
  pdbfixer           conda-forge/noarch::pdbfixer-1.7-pyhd3deb0d_0
  python_abi         conda-forge/linux-64::python_abi-3.7-2_cp37m
  six                conda-forge/noarch::six-1.16.0-pyh6c4a22f_0
  toolz              conda-forge/noarch::toolz-0.12.0-pyhd8ed1ab_0

The following packages will be REMOVED:

  brotlipy-0.7.0-py39h27cfd23_1003

The following packages will be UPDATED:

  conda              pkgs/main::conda-4.13.0-py39h06a4308_0 --> conda-forge::conda-4.14.0-py37h89c1867_0
  conda-package-han~ pkgs/main::conda-package-handling-1.8~ --> conda-forge::conda-package-handling-1.8.1-py37h540881e_1
  cryptography       pkgs/main::cryptography-37.0.1-py39h9~ --> conda-forge::cryptography-37.0.2-py37h38fbfac_0
  pip                pkgs/main/linux-64::pip-22.1.2-py39h0~ --> conda-forge/noarch::pip-22.2.2-pyhd8ed1ab_0
  pycosat            pkgs/main::pycosat-0.6.3-py39h27cfd23~ --> conda-forge::pycosat-0.6.3-py37h540881e_1010
  pysocks            pkgs/main::pysocks-1.7.1-py39h06a4308~ --> conda-forge::pysocks-1.7.1-py37h89c1867_5
  setuptools         pkgs/main::setuptools-61.2.0-py39h06a~ --> conda-forge::setuptools-65.0.2-py37h89c1867_0

The following packages will be SUPERSEDED by a higher-priority channel:

  ca-certificates    pkgs/main::ca-certificates-2022.07.19~ --> conda-forge::ca-certificates-2022.6.15-ha878542_0
  certifi            pkgs/main::certifi-2022.6.15-py39h06a~ --> conda-forge::certifi-2022.6.15-py37h89c1867_0
  cffi                pkgs/main::cffi-1.15.1-py39h74dc2b5_0 --> conda-forge::cffi-1.14.6-py37hc58025e_0
  openssl              pkgs/main::openssl-1.1.1q-h7f8727e_0 --> conda-forge::openssl-1.1.1o-h166bdaf_0
  python                pkgs/main::python-3.9.12-h12debd9_0 --> conda-forge::python-3.7.10-hffdb5ce_100_cpython
  requests           pkgs/main/linux-64::requests-2.28.1-p~ --> conda-forge/noarch::requests-2.28.1-pyhd8ed1ab_0
  ruamel_yaml        pkgs/main::ruamel_yaml-0.15.100-py39h~ --> conda-forge::ruamel_yaml-0.15.80-py37h5e8e339_1006
  tqdm               pkgs/main/linux-64::tqdm-4.64.0-py39h~ --> conda-forge/noarch::tqdm-4.64.0-pyhd8ed1ab_0
  urllib3            pkgs/main::urllib3-1.26.11-py39h06a43~ --> conda-forge::urllib3-1.25.8-py37hc8dfbb8_1



Downloading and Extracting Packages
cryptography-37.0.2  | 1.5 MB    | ########## | 100% 
libcblas-3.9.0       | 12 KB     | ########## | 100% 
cudatoolkit-11.1.1   | 1.20 GB   | ########## | 100% 
libgfortran5-12.1.0  | 1.8 MB    | ########## | 100% 
tqdm-4.64.0          | 81 KB     | ########## | 100% 
libopenblas-0.3.20   | 10.1 MB   | ########## | 100% 
python-3.7.10        | 57.3 MB   | ########## | 100% 
toolz-0.12.0         | 48 KB     | ########## | 100% 
ruamel_yaml-0.15.80  | 270 KB    | ########## | 100% 
urllib3-1.25.8       | 160 KB    | ########## | 100% 
pdbfixer-1.7         | 167 KB    | ########## | 100% 
conda-package-handli | 1.0 MB    | ########## | 100% 
certifi-2022.6.15    | 155 KB    | ########## | 100% 
colorama-0.4.5       | 18 KB     | ########## | 100% 
ca-certificates-2022 | 149 KB    | ########## | 100% 
pysocks-1.7.1        | 28 KB     | ########## | 100% 
ocl-icd-system-1.0.0 | 4 KB      | ########## | 100% 
six-1.16.0           | 14 KB     | ########## | 100% 
setuptools-65.0.2    | 1.4 MB    | ########## | 100% 
pycosat-0.6.3        | 107 KB    | ########## | 100% 
openmm-7.5.1         | 10.7 MB   | ########## | 100% 
libgfortran-ng-12.1. | 23 KB     | ########## | 100% 
fftw-3.3.10          | 6.4 MB    | ########## | 100% 
ocl-icd-2.3.1        | 119 KB    | ########## | 100% 
python_abi-3.7       | 4 KB      | ########## | 100% 
numpy-1.21.6         | 6.1 MB    | ########## | 100% 
cffi-1.14.6          | 225 KB    | ########## | 100% 
pip-22.2.2           | 1.5 MB    | ########## | 100% 
openssl-1.1.1o       | 2.1 MB    | ########## | 100% 
requests-2.28.1      | 53 KB     | ########## | 100% 
conda-4.14.0         | 1010 KB   | ########## | 100% 
libblas-3.9.0        | 12 KB     | ########## | 100% 
liblapack-3.9.0      | 12 KB     | ########## | 100% 
Preparing transaction: ...working... done
Verifying transaction: ...working... done
Executing transaction: ...working... By downloading and using the CUDA Toolkit conda packages, you accept the terms and conditions of the CUDA End User License Agreement (EULA): https://docs.nvidia.com/cuda/eula/index.html

done
Removing intermediate container b479fe3ee749
 ---> ca27b5a16cf6
Step 10/18 : COPY . /app/alphafold
 ---> 615722fdb768
Step 11/18 : RUN wget -q -P /app/alphafold/alphafold/common/   https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
 ---> Running in 97660456ed02
Removing intermediate container 97660456ed02
 ---> 4ed31478dec1
Step 12/18 : RUN pip3 install --upgrade pip     && pip3 install -r /app/alphafold/requirements.txt     && pip3 install --upgrade       jax==0.2.14       jaxlib==0.1.69+cuda$(cut -f1,2 -d. <<< ${CUDA} | sed 's/\.//g')       -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
 ---> Running in f99f777d4868
Requirement already satisfied: pip in /opt/conda/lib/python3.7/site-packages (22.2.2)
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Collecting absl-py==0.13.0
  Downloading absl_py-0.13.0-py3-none-any.whl (132 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 132.1/132.1 kB 1.0 MB/s eta 0:00:00
Collecting biopython==1.79
  Downloading biopython-1.79-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (2.3 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.3/2.3 MB 6.3 MB/s eta 0:00:00
Collecting chex==0.0.7
  Downloading chex-0.0.7-py3-none-any.whl (52 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 52.5/52.5 kB 1.5 MB/s eta 0:00:00
Collecting dm-haiku==0.0.4
  Downloading dm_haiku-0.0.4-py3-none-any.whl (284 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 284.5/284.5 kB 5.5 MB/s eta 0:00:00
Collecting dm-tree==0.1.6
  Downloading dm_tree-0.1.6-cp37-cp37m-manylinux_2_24_x86_64.whl (93 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 94.0/94.0 kB 1.0 MB/s eta 0:00:00
Collecting docker==5.0.0
  Downloading docker-5.0.0-py2.py3-none-any.whl (146 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 147.0/147.0 kB 2.5 MB/s eta 0:00:00
Collecting immutabledict==2.0.0
  Downloading immutabledict-2.0.0-py3-none-any.whl (4.0 kB)
Collecting jax==0.2.14
  Downloading jax-0.2.14.tar.gz (669 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 669.2/669.2 kB 7.4 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting ml-collections==0.1.0
  Downloading ml_collections-0.1.0-py3-none-any.whl (88 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 88.7/88.7 kB 2.8 MB/s eta 0:00:00
Collecting numpy==1.19.5
  Downloading numpy-1.19.5-cp37-cp37m-manylinux2010_x86_64.whl (14.8 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 14.8/14.8 MB 949.8 kB/s eta 0:00:00
Collecting pandas==1.3.4
  Downloading pandas-1.3.4-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (11.3 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 11.3/11.3 MB 2.1 MB/s eta 0:00:00
Collecting protobuf==3.20.1
  Downloading protobuf-3.20.1-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (1.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.0/1.0 MB 2.2 MB/s eta 0:00:00
Collecting scipy==1.7.0
  Downloading scipy-1.7.0-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.whl (28.5 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 28.5/28.5 MB 1.5 MB/s eta 0:00:00
Collecting tensorflow-cpu==2.5.0
  Downloading tensorflow_cpu-2.5.0-cp37-cp37m-manylinux2010_x86_64.whl (168.3 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 168.3/168.3 MB 1.2 MB/s eta 0:00:00
Requirement already satisfied: six in /opt/conda/lib/python3.7/site-packages (from absl-py==0.13.0->-r /app/alphafold/requirements.txt (line 1)) (1.16.0)
Collecting jaxlib>=0.1.37
  Downloading jaxlib-0.3.15-cp37-none-manylinux2014_x86_64.whl (72.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 72.0/72.0 MB 1.7 MB/s eta 0:00:00
Requirement already satisfied: toolz>=0.9.0 in /opt/conda/lib/python3.7/site-packages (from chex==0.0.7->-r /app/alphafold/requirements.txt (line 3)) (0.12.0)
Collecting tabulate>=0.8.9
  Downloading tabulate-0.8.10-py3-none-any.whl (29 kB)
Collecting typing-extensions
  Downloading typing_extensions-4.3.0-py3-none-any.whl (25 kB)
Collecting websocket-client>=0.32.0
  Downloading websocket_client-1.3.3-py3-none-any.whl (54 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 54.3/54.3 kB 1.0 MB/s eta 0:00:00
Requirement already satisfied: requests!=2.18.0,>=2.14.2 in /opt/conda/lib/python3.7/site-packages (from docker==5.0.0->-r /app/alphafold/requirements.txt (line 6)) (2.28.1)
Collecting opt_einsum
  Downloading opt_einsum-3.3.0-py3-none-any.whl (65 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 65.5/65.5 kB 1.1 MB/s eta 0:00:00
Collecting PyYAML
  Downloading PyYAML-6.0-cp37-cp37m-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (596 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 596.3/596.3 kB 1.8 MB/s eta 0:00:00
Collecting contextlib2
  Downloading contextlib2-21.6.0-py2.py3-none-any.whl (13 kB)
Collecting pytz>=2017.3
  Downloading pytz-2022.2.1-py2.py3-none-any.whl (500 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 500.6/500.6 kB 1.9 MB/s eta 0:00:00
Collecting python-dateutil>=2.7.3
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 247.7/247.7 kB 1.9 MB/s eta 0:00:00
Collecting keras-preprocessing~=1.1.2
  Downloading Keras_Preprocessing-1.1.2-py2.py3-none-any.whl (42 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 42.6/42.6 kB 948.4 kB/s eta 0:00:00
Collecting six
  Downloading six-1.15.0-py2.py3-none-any.whl (10 kB)
Collecting tensorflow-estimator<2.6.0,>=2.5.0rc0
  Downloading tensorflow_estimator-2.5.0-py2.py3-none-any.whl (462 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 462.4/462.4 kB 2.0 MB/s eta 0:00:00
Collecting google-pasta~=0.2
  Downloading google_pasta-0.2.0-py3-none-any.whl (57 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 57.5/57.5 kB 1.1 MB/s eta 0:00:00
Collecting flatbuffers~=1.12.0
  Downloading flatbuffers-1.12-py2.py3-none-any.whl (15 kB)
Collecting keras-nightly~=2.5.0.dev
  Downloading keras_nightly-2.5.0.dev2021032900-py2.py3-none-any.whl (1.2 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.2/1.2 MB 2.1 MB/s eta 0:00:00
Requirement already satisfied: wheel~=0.35 in /opt/conda/lib/python3.7/site-packages (from tensorflow-cpu==2.5.0->-r /app/alphafold/requirements.txt (line 14)) (0.37.1)
Collecting h5py~=3.1.0
  Downloading h5py-3.1.0-cp37-cp37m-manylinux1_x86_64.whl (4.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.0/4.0 MB 1.4 MB/s eta 0:00:00
Collecting astunparse~=1.6.3
  Downloading astunparse-1.6.3-py2.py3-none-any.whl (12 kB)
Collecting gast==0.4.0
  Downloading gast-0.4.0-py3-none-any.whl (9.8 kB)
Collecting grpcio~=1.34.0
  Downloading grpcio-1.34.1-cp37-cp37m-manylinux2014_x86_64.whl (4.0 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.0/4.0 MB 1.8 MB/s eta 0:00:00
Collecting typing-extensions
  Downloading typing_extensions-3.7.4.3-py3-none-any.whl (22 kB)
Collecting termcolor~=1.1.0
  Downloading termcolor-1.1.0.tar.gz (3.9 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting tensorboard~=2.5
  Downloading tensorboard-2.10.0-py3-none-any.whl (5.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 5.9/5.9 MB 2.6 MB/s eta 0:00:00
Collecting wrapt~=1.12.1
  Downloading wrapt-1.12.1.tar.gz (27 kB)
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting cached-property
  Downloading cached_property-1.5.2-py2.py3-none-any.whl (7.6 kB)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /opt/conda/lib/python3.7/site-packages (from requests!=2.18.0,>=2.14.2->docker==5.0.0->-r /app/alphafold/requirements.txt (line 6)) (1.25.8)
Requirement already satisfied: idna<4,>=2.5 in /opt/conda/lib/python3.7/site-packages (from requests!=2.18.0,>=2.14.2->docker==5.0.0->-r /app/alphafold/requirements.txt (line 6)) (3.3)
Requirement already satisfied: certifi>=2017.4.17 in /opt/conda/lib/python3.7/site-packages (from requests!=2.18.0,>=2.14.2->docker==5.0.0->-r /app/alphafold/requirements.txt (line 6)) (2022.6.15)
Requirement already satisfied: charset-normalizer<3,>=2 in /opt/conda/lib/python3.7/site-packages (from requests!=2.18.0,>=2.14.2->docker==5.0.0->-r /app/alphafold/requirements.txt (line 6)) (2.0.4)
Collecting werkzeug>=1.0.1
  Downloading Werkzeug-2.2.2-py3-none-any.whl (232 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 232.7/232.7 kB 2.0 MB/s eta 0:00:00
Collecting tensorboard-plugin-wit>=1.6.0
  Downloading tensorboard_plugin_wit-1.8.1-py3-none-any.whl (781 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 781.3/781.3 kB 2.7 MB/s eta 0:00:00
Collecting tensorboard~=2.5
  Downloading tensorboard-2.9.1-py3-none-any.whl (5.8 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 5.8/5.8 MB 2.1 MB/s eta 0:00:00
  Downloading tensorboard-2.9.0-py3-none-any.whl (5.8 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 5.8/5.8 MB 2.0 MB/s eta 0:00:00
Collecting google-auth<3,>=1.6.3
  Downloading google_auth-2.10.0-py2.py3-none-any.whl (167 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 167.2/167.2 kB 1.8 MB/s eta 0:00:00
Collecting tensorboard-data-server<0.7.0,>=0.6.0
  Downloading tensorboard_data_server-0.6.1-py3-none-manylinux2010_x86_64.whl (4.9 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.9/4.9 MB 2.8 MB/s eta 0:00:00
Requirement already satisfied: setuptools>=41.0.0 in /opt/conda/lib/python3.7/site-packages (from tensorboard~=2.5->tensorflow-cpu==2.5.0->-r /app/alphafold/requirements.txt (line 14)) (65.0.2)
Collecting google-auth-oauthlib<0.5,>=0.4.1
  Downloading google_auth_oauthlib-0.4.6-py2.py3-none-any.whl (18 kB)
Collecting markdown>=2.6.8
  Downloading Markdown-3.4.1-py3-none-any.whl (93 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 93.3/93.3 kB 1.8 MB/s eta 0:00:00
Collecting cachetools<6.0,>=2.0.0
  Downloading cachetools-5.2.0-py3-none-any.whl (9.3 kB)
Collecting rsa<5,>=3.1.4
  Downloading rsa-4.9-py3-none-any.whl (34 kB)
Collecting pyasn1-modules>=0.2.1
  Downloading pyasn1_modules-0.2.8-py2.py3-none-any.whl (155 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 155.3/155.3 kB 2.2 MB/s eta 0:00:00
Collecting requests-oauthlib>=0.7.0
  Downloading requests_oauthlib-1.3.1-py2.py3-none-any.whl (23 kB)
Collecting importlib-metadata>=4.4
  Downloading importlib_metadata-4.12.0-py3-none-any.whl (21 kB)
Collecting MarkupSafe>=2.1.1
  Downloading MarkupSafe-2.1.1-cp37-cp37m-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting zipp>=0.5
  Downloading zipp-3.8.1-py3-none-any.whl (5.6 kB)
Collecting pyasn1<0.5.0,>=0.4.6
  Downloading pyasn1-0.4.8-py2.py3-none-any.whl (77 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 77.1/77.1 kB 1.6 MB/s eta 0:00:00
Collecting oauthlib>=3.0.0
  Downloading oauthlib-3.2.0-py3-none-any.whl (151 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 151.5/151.5 kB 2.0 MB/s eta 0:00:00
Building wheels for collected packages: jax, termcolor, wrapt
  Building wheel for jax (setup.py): started
  Building wheel for jax (setup.py): finished with status 'done'
  Created wheel for jax: filename=jax-0.2.14-py3-none-any.whl size=771334 sha256=88ce3f87ab3f21afaa48e225619bf146c5ac48d84c26d938fc31f3e0a953d6c2
  Stored in directory: /root/.cache/pip/wheels/ec/bd/25/923906d87d262ee0be5c68b248d1a8249d028603582a256266
  Building wheel for termcolor (setup.py): started
  Building wheel for termcolor (setup.py): finished with status 'done'
  Created wheel for termcolor: filename=termcolor-1.1.0-py3-none-any.whl size=4832 sha256=29307edcd95d738c0534abb583bc7b5ed030528ebc20993545351080aceede78
  Stored in directory: /root/.cache/pip/wheels/3f/e3/ec/8a8336ff196023622fbcb36de0c5a5c218cbb24111d1d4c7f2
  Building wheel for wrapt (setup.py): started
  Building wheel for wrapt (setup.py): finished with status 'done'
  Created wheel for wrapt: filename=wrapt-1.12.1-cp37-cp37m-linux_x86_64.whl size=70825 sha256=098a53bd28ce41406aa898f38e846cd6b23e598011f238dd6fa886787c675eb9
  Stored in directory: /root/.cache/pip/wheels/62/76/4c/aa25851149f3f6d9785f6c869387ad82b3fd37582fa8147ac6
Successfully built jax termcolor wrapt
Installing collected packages: wrapt, typing-extensions, termcolor, tensorflow-estimator, tensorboard-plugin-wit, pytz, pyasn1, keras-nightly, flatbuffers, cached-property, zipp, websocket-client, tensorboard-data-server, tabulate, six, rsa, PyYAML, pyasn1-modules, protobuf, oauthlib, numpy, MarkupSafe, immutabledict, gast, contextlib2, cachetools, werkzeug, scipy, requests-oauthlib, python-dateutil, opt_einsum, keras-preprocessing, importlib-metadata, h5py, grpcio, google-pasta, google-auth, docker, dm-tree, biopython, astunparse, absl-py, pandas, ml-collections, markdown, jaxlib, jax, google-auth-oauthlib, dm-haiku, tensorboard, chex, tensorflow-cpu
  Attempting uninstall: six
    Found existing installation: six 1.16.0
    Uninstalling six-1.16.0:
      Successfully uninstalled six-1.16.0
  Attempting uninstall: numpy
    Found existing installation: numpy 1.21.6
    Uninstalling numpy-1.21.6:
      Successfully uninstalled numpy-1.21.6
Successfully installed MarkupSafe-2.1.1 PyYAML-6.0 absl-py-0.13.0 astunparse-1.6.3 biopython-1.79 cached-property-1.5.2 cachetools-5.2.0 chex-0.0.7 contextlib2-21.6.0 dm-haiku-0.0.4 dm-tree-0.1.6 docker-5.0.0 flatbuffers-1.12 gast-0.4.0 google-auth-2.10.0 google-auth-oauthlib-0.4.6 google-pasta-0.2.0 grpcio-1.34.1 h5py-3.1.0 immutabledict-2.0.0 importlib-metadata-4.12.0 jax-0.2.14 jaxlib-0.3.15 keras-nightly-2.5.0.dev2021032900 keras-preprocessing-1.1.2 markdown-3.4.1 ml-collections-0.1.0 numpy-1.19.5 oauthlib-3.2.0 opt_einsum-3.3.0 pandas-1.3.4 protobuf-3.20.1 pyasn1-0.4.8 pyasn1-modules-0.2.8 python-dateutil-2.8.2 pytz-2022.2.1 requests-oauthlib-1.3.1 rsa-4.9 scipy-1.7.0 six-1.15.0 tabulate-0.8.10 tensorboard-2.9.0 tensorboard-data-server-0.6.1 tensorboard-plugin-wit-1.8.1 tensorflow-cpu-2.5.0 tensorflow-estimator-2.5.0 termcolor-1.1.0 typing-extensions-3.7.4.3 websocket-client-1.3.3 werkzeug-2.2.2 wrapt-1.12.1 zipp-3.8.1
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Looking in links: https://storage.googleapis.com/jax-releases/jax_cuda_releases.html
Requirement already satisfied: jax==0.2.14 in /opt/conda/lib/python3.7/site-packages (0.2.14)
Collecting jaxlib==0.1.69+cuda111
  Downloading https://storage.googleapis.com/jax-releases/cuda111/jaxlib-0.1.69%2Bcuda111-cp37-none-manylinux2010_x86_64.whl (196.5 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 196.5/196.5 MB 1.5 MB/s eta 0:00:00
Requirement already satisfied: numpy>=1.12 in /opt/conda/lib/python3.7/site-packages (from jax==0.2.14) (1.19.5)
Requirement already satisfied: opt-einsum in /opt/conda/lib/python3.7/site-packages (from jax==0.2.14) (3.3.0)
Requirement already satisfied: absl-py in /opt/conda/lib/python3.7/site-packages (from jax==0.2.14) (0.13.0)
Requirement already satisfied: flatbuffers<3.0,>=1.12 in /opt/conda/lib/python3.7/site-packages (from jaxlib==0.1.69+cuda111) (1.12)
Requirement already satisfied: scipy in /opt/conda/lib/python3.7/site-packages (from jaxlib==0.1.69+cuda111) (1.7.0)
Requirement already satisfied: six in /opt/conda/lib/python3.7/site-packages (from absl-py->jax==0.2.14) (1.15.0)
Installing collected packages: jaxlib
  Attempting uninstall: jaxlib
    Found existing installation: jaxlib 0.3.15
    Uninstalling jaxlib-0.3.15:
      Successfully uninstalled jaxlib-0.3.15
Successfully installed jaxlib-0.1.69+cuda111
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Removing intermediate container f99f777d4868
 ---> c0028331904d
Step 13/18 : WORKDIR /opt/conda/lib/python3.7/site-packages
 ---> Running in 85498ade152f
Removing intermediate container 85498ade152f
 ---> 6f3582890aa8
Step 14/18 : RUN patch -p0 < /app/alphafold/docker/openmm.patch
 ---> Running in b34664dbb490
patching file simtk/openmm/app/topology.py
Hunk #1 succeeded at 353 (offset -3 lines).
Removing intermediate container b34664dbb490
 ---> b093a8603ba3
Step 15/18 : RUN chmod u+s /sbin/ldconfig.real
 ---> Running in 27660b373587
Removing intermediate container 27660b373587
 ---> fea927e976f6
Step 16/18 : WORKDIR /app/alphafold
 ---> Running in 4cc9547f033a
Removing intermediate container 4cc9547f033a
 ---> beeccc62dc0d
Step 17/18 : RUN echo $'#!/bin/bash\nldconfig\npython /app/alphafold/run_alphafold.py "$@"' > /app/run_alphafold.sh   && chmod +x /app/run_alphafold.sh
 ---> Running in c439edd89a40
Removing intermediate container c439edd89a40
 ---> 8e4dccb63fd5
Step 18/18 : ENTRYPOINT ["/app/run_alphafold.sh"]
 ---> Running in 259e07eb252e
Removing intermediate container 259e07eb252e
 ---> 1db17d1b0e93
Successfully built 1db17d1b0e93
```

3. Install the `run_docker.py` dependencies. Note: You may optionally wish to create a [Python Virtual Environment](https://docs.python.org/3/tutorial/venv.html) to prevent conflicts with your system's Python environment.

```
~/alphafold$ pip3 install -r docker/requirements.txt

Command 'pip3' not found, but can be installed with:

sudo apt install python3-pip
```
Oops.

```
~/alphafold$ sudo apt install python3-pip
[sudo] password for luolab: 
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  python-pip-whl python3-setuptools python3-wheel
Suggested packages:
  python-setuptools-doc
The following NEW packages will be installed:
  python-pip-whl python3-pip python3-setuptools python3-wheel
0 upgraded, 4 newly installed, 0 to remove and 10 not upgraded.
Need to get 2,389 kB of archives.
After this operation, 4,932 kB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe amd64 python-pip-whl all 20.0.2-5ubuntu1.6 [1,805 kB]
Get:2 http://cn.archive.ubuntu.com/ubuntu focal/main amd64 python3-setuptools all 45.2.0-1 [330 kB]                  
Get:3 http://cn.archive.ubuntu.com/ubuntu focal/universe amd64 python3-wheel all 0.34.2-1 [23.8 kB]                  
Get:4 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe amd64 python3-pip all 20.0.2-5ubuntu1.6 [231 kB]    
Fetched 2,389 kB in 9s (262 kB/s)                                                                                    
Selecting previously unselected package python-pip-whl.
(Reading database ... 310709 files and directories currently installed.)
Preparing to unpack .../python-pip-whl_20.0.2-5ubuntu1.6_all.deb ...
Unpacking python-pip-whl (20.0.2-5ubuntu1.6) ...
Selecting previously unselected package python3-setuptools.
Preparing to unpack .../python3-setuptools_45.2.0-1_all.deb ...
Unpacking python3-setuptools (45.2.0-1) ...
Selecting previously unselected package python3-wheel.
Preparing to unpack .../python3-wheel_0.34.2-1_all.deb ...
Unpacking python3-wheel (0.34.2-1) ...
Selecting previously unselected package python3-pip.
Preparing to unpack .../python3-pip_20.0.2-5ubuntu1.6_all.deb ...
Unpacking python3-pip (20.0.2-5ubuntu1.6) ...
Setting up python3-setuptools (45.2.0-1) ...
Setting up python3-wheel (0.34.2-1) ...
Setting up python-pip-whl (20.0.2-5ubuntu1.6) ...
Setting up python3-pip (20.0.2-5ubuntu1.6) ...
Processing triggers for man-db (2.9.1-1) ...
```

First time using Python to manage virtual environments.

```
(base) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ conda deactivate
luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ python3 -m venv alphafold2
The virtual environment was not created successfully because ensurepip is not
available.  On Debian/Ubuntu systems, you need to install the python3-venv
package using the following command.

    apt install python3.8-venv

You may need to use sudo with that command.  After installing the python3-venv
package, recreate your virtual environment.

Failing command: ['/home/luolab/GITHUB_REPO/alphafold/alphafold2/bin/python3', '-Im', 'ensurepip', '--upgrade', '--default-pip']
```

```
luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ sudo apt install python3.8-venv
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  python3.8-venv
0 upgraded, 1 newly installed, 0 to remove and 10 not upgraded.
Need to get 5,444 B of archives.
After this operation, 27.6 kB of additional disk space will be used.
Get:1 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe amd64 python3.8-venv amd64 3.8.10-0ubuntu1~20.04.5 [5,444 B]
Fetched 5,444 B in 1s (8,694 B/s)          
Selecting previously unselected package python3.8-venv.
(Reading database ... 311073 files and directories currently installed.)
Preparing to unpack .../python3.8-venv_3.8.10-0ubuntu1~20.04.5_amd64.deb ...
Unpacking python3.8-venv (3.8.10-0ubuntu1~20.04.5) ...
Setting up python3.8-venv (3.8.10-0ubuntu1~20.04.5) ...
```

```
luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ python3 -m venv ~/.virtualenvs/alphafold2
luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ source ~/.virtualenvs/alphafold2/bin/activate
```

Confirm that venv is properly setup:
```
(alphafold2) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ which python
/home/luolab/.virtualenvs/alphafold2/bin/python
```

To leave the virtualenv, simply do:
```
(alphafold2) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ deactivate
```

Now install dependencies:
```
(alphafold2) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ pip3 install -r docker/requirements.txt
Collecting absl-py==0.13.0
  Using cached absl_py-0.13.0-py3-none-any.whl (132 kB)
Collecting docker==5.0.0
  Downloading docker-5.0.0-py2.py3-none-any.whl (146 kB)
     |████████████████████████████████| 146 kB 1.1 MB/s 
Collecting six
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting websocket-client>=0.32.0
  Using cached websocket_client-1.3.3-py3-none-any.whl (54 kB)
Collecting requests!=2.18.0,>=2.14.2
  Using cached requests-2.28.1-py3-none-any.whl (62 kB)
Collecting charset-normalizer<3,>=2
  Using cached charset_normalizer-2.1.0-py3-none-any.whl (39 kB)
Collecting certifi>=2017.4.17
  Using cached certifi-2022.6.15-py3-none-any.whl (160 kB)
Collecting idna<4,>=2.5
  Using cached idna-3.3-py3-none-any.whl (61 kB)
Collecting urllib3<1.27,>=1.21.1
  Using cached urllib3-1.26.11-py2.py3-none-any.whl (139 kB)
Installing collected packages: six, absl-py, websocket-client, charset-normalizer, certifi, idna, urllib3, requests, docker
Successfully installed absl-py-0.13.0 certifi-2022.6.15 charset-normalizer-2.1.0 docker-5.0.0 idna-3.3 requests-2.28.1 six-1.16.0 urllib3-1.26.11 websocket-client-1.3.3
```

4. Make sure that the output directory exists (the default is `/tmp/alphafold`) and that you have sufficient permissions to write into it. You can make sure that is the case by manually running `mkdir /tmp/alphafold` and `chmod 770 /tmp/alphafold`.

```
(alphafold2) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ mkdir /tmp/alphafold
(alphafold2) luolab@luolab-Z10PE-D16-WS:~/GITHUB_REPO/alphafold$ chmod 770 /tmp/alphafold/
```
