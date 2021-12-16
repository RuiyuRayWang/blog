---
title:       "Building System & Environment Support for Tensorflow on Ubuntu"
subtitle:    "First Dive into Deep Learning"
description: ""
date:        2021-12-05T22:57:25+08:00
author:      Ruiyu Wang
image:       ""
tags:        ["Tensorflow", "Ubuntu", "Deep Learning", "Single Cell Biology"]
categories:  ["Tech" ]
---

As promised, I will write about my experience with installing tensorflow. 

Why did I ever have to build Tensorflow myself?  
The reason is that I was trying to using two tools: `cellassign` and `Cell_BLAST`, but they depend on different tensorflow versions. To make them both work, I experimented with a build strategy that alhavelows different Tensorflow versions installed and run in separate conda environments.

References: 
    - [link1](https://blog.kovalevskyi.com/multiple-version-of-cuda-libraries-on-the-same-machine-b9502d50ae77): best post for the job
    - [link2](https://stackoverflow.com/questions/41330798/install-multiple-versions-of-cuda-and-cudnn)
    - [link3](https://towardsdatascience.com/installing-multiple-cuda-cudnn-versions-in-ubuntu-fcb6aa5194e2) 

Since I don't have time to write too much, I'll make things brief.

## TL;DR

The recommended way is to **build from source**.

### 1. Purge previous installations:
```
## Purge previous installations
$ sudo apt-get --purge remove "*cublas*" "cuda*" "nsight*"
$ sudo apt-get --purge remove "*nvidia*"
$ sudo rf -rf /usr/local/cuda*  ## source files
$ sudo vim /etc/apt/sources.list  ## Fix repo: remove all entries with referece to "nvidia"
$ sudo apt-get update
$ sudo apt autoremove
```

### 2. Install NVIDIA driver. [Download page](https://www.nvidia.com/download/index.aspx?lang=en-us).
>There is only one requirement, that one needs to satisfy in order to install multiple CUDA on the same machine. You need to have latest Nvidia driver that is required by the highest CUDA that you’re going to install. Usually it is a good idea to install precise driver that was used during the build of CUDA.
```
$ sudo ./NVIDIA-Linux-x86_64_470.86.run
... ...
ERROR: Nouveau kernel driver is currently in use by your system. ... For some distributions, Nouveau can be disabled by adding a file in the modprobe configuration directory. Would you like nvidia-installer to attempt to create this modprobe file for you? (Answer: Yes)
... ...
Note if you later wish to re-enable Nouveau, you will need to delete these files: /etc/modprobe.d/nvidia-installer-disable-nouveau.conf
$ reboot
```

After reboot there will be no GUI (because the driver for graphics card has been disabled). I logged in remotely to run:
```
$ sudo ./NVIDIA-Linux-x86_64_470.86.run
```
And followed the instructions to install the driver.

Reboot the system after the driver has been properly installed. Check that the driver works by:
```
$ nvidia-smi
Thu Dec 16 16:32:13 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 450.51.06    Driver Version: 450.51.06    CUDA Version: 11.0     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro M4000        On   | 00000000:02:00.0  On |                  N/A |
| 53%   55C    P8    15W / 120W |    514MiB /  8125MiB |      8%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      2126      G   /usr/lib/xorg/Xorg                187MiB |
|    0   N/A  N/A      2545      G   /usr/bin/gnome-shell              203MiB |
|    0   N/A  N/A      7112      G   /usr/lib/rstudio/bin/rstudio       97MiB |
|    0   N/A  N/A     12153      G   /usr/lib/firefox/firefox            2MiB |
|    0   N/A  N/A     19111      G   /usr/lib/firefox/firefox            2MiB |
|    0   N/A  N/A     21047      G   /usr/lib/firefox/firefox            2MiB |
|    0   N/A  N/A     25663      G   /usr/lib/firefox/firefox            2MiB |
|    0   N/A  N/A     27497      G   /usr/lib/firefox/firefox            2MiB |
|    0   N/A  N/A     39185      G   /usr/lib/firefox/firefox            2MiB |
+-----------------------------------------------------------------------------+
```

### 3. Install the "CUDA stack"

According to the [kovalevskyi](https://blog.kovalevskyi.com/multiple-version-of-cuda-libraries-on-the-same-machine-b9502d50ae77) guide, it's better to use CUDA runfile (local) installers.
>I would strongly recommend use the installer script. First of all, it is agnostic to the version of the Linux that is used. Secondly, unlike some binary pre-build packages like deb file you can control where exactly CUDA library files will be installed.

Download CUDA Toolkit installers [here](https://developer.nvidia.com/cuda-toolkit-archive).
```
$ wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
$ sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
$ wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda-repo-ubuntu1804-11-0-local_11.0.3-450.51.06-1_amd64.deb
$ sudo dpkg -i cuda-repo-ubuntu1804-11-0-local_11.0.3-450.51.06-1_amd64.deb
$ sudo apt-key add /var/cuda-repo-ubuntu1804-11-0-local/7fa2af80.pub
$ sudo apt-get update
$ sudo apt-get -y install cuda
```

When installing the second CUDA Toolkit, replace the last command with 




To build multiple Tensorflow versions, there will be various compatibilities requirements. Consider the followings:

    - Tool of interest
        What tool will be tensorflow used for? What version of tensorflow does it depends on? These are the first things you should consider.  
        Unless using tensorflow for standalone purposes, you will have to choose a tensorflow version that is compatible with your tool. Many tools are written with legacy (older) versions of tensorflow, and they may not run properly with newer versions. Make sure to install the appropriate one. For example in my case, `cellassign` requires `tensorflow >= 2.1.0`, whereas `Cell_BLAST` requires `tensorflow == 1.12.0`. These belong to two different MAJOR versions of tensorflow: `1.x.x` and `2.x.x`. Tensorflow MAJOR versions are quite different and are usually **NOT** interchangable.  
        If using tensorflow-gpu, there is also different dependencies on CUDA and cuDNN which you have to be aware about (see below).
    - Tensorflow
        Like I said above, tensorflow `MAJOR` versions can have a big difference. **Remember to build dedicated environments** for **each tool** with the required Tensorflow inside it. In my case, I created two environments, one with `Tensorflow>=2.1.0` and `cellassign` installed, and the other with `Tensorflow==1.12.0` and `Cell_BLAST` installed.  
        For tensorflow-gpu, the decision of whether or not to install it depends on the tool you'll be using and on whether you think your task requires parallel computing. CPU can run properly with any task, but if the task is computationally expensive, you may want to try GPU versions of tensorflow.
    - GCC
        GCC is used for `make` build some package dependencies during tensorflow installations. I did not run into any issue with gcc on my machine. In the installation procedures, there's a step that explicitly checks gcc version. If you find a gcc trouble, just upgrade it and you'll be fine.
    - Ubuntu
        16.04? 18.04? or others? For some older versions of tensorflow, NVIDIA download page may not provide download links for the latest Ubuntu releases. But don't worry. I find that the Ubuntu release version doesn't have to be strictly followed. For example, for `tensorflow == 1.12.0` I had to install CUDA 9.0 over 18.04, but there's no CUDA 9.0 release for a 18.04 system, so I made an arbitrary choice: Download CUDA 9.0 for Ubuntu 16.04 and install it on 18.04. By now there seem to be no obvious issue. So don't be too prudent about this and experiment yourself!
    - CUDA & cuDNN
        The compatibilities between CUDA and cuDNN, as well as Tensorflow, python and gcc can be found [here](https://www.tensorflow.org/install/source#gpu). If you use different versions of Tensorflow on the same machine, like above for `cellassign` and `Cell BLAST`, you'll have to make multiple CUDA & cuDNN builts. For example, I've built on my machine `CUDA 9.0 & cuDNN 7.3.1` for `Cell BLAST` with `Tensorflow==1.12.0`, and `CUDA 11.0 & cuDNN 8.0.4` for `cellassign` with `Tensorflow==2.4.0`.

