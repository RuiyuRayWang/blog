---
title:       "Building Environments for Cellassign and CellBLAST with multiple GPU Supported Tensorflow Versions on Ubuntu"
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
The reason is that I was trying to use two tools: `cellassign` and `Cell_BLAST`, but they depend on different tensorflow versions. To make them both work, I used the following build strategy that allows different Tensorflow versions installed and run in separate conda environments.

References: 
    - [link1](https://blog.kovalevskyi.com/multiple-version-of-cuda-libraries-on-the-same-machine-b9502d50ae77): Best post for the job
    - [link2](https://www.tensorflow.org/install/gpu): Official guide
    - [link3](https://stackoverflow.com/questions/41330798/install-multiple-versions-of-cuda-and-cudnn)
    - [link4](https://towardsdatascience.com/installing-multiple-cuda-cudnn-versions-in-ubuntu-fcb6aa5194e2) 

Since I don't have time to write too much, I'll try to make things brief.

# TL;DR

## 1. Purge previous installations:
```
## Purge previous installations
$ sudo apt-get --purge remove "*cublas*" "cuda*" "nsight*"
$ sudo apt-get --purge remove "*nvidia*"
$ sudo rf -rf /usr/local/cuda*  ## source files
$ sudo vim /etc/apt/sources.list  ## Fix repo: remove all entries with referece to "nvidia"
$ sudo apt-get update
$ sudo apt autoremove
```

```
$ sudo apt-key list
```

Removed two GPG keys:
```
/etc/apt/trusted.gpg
--------------------
pub   rsa4096 2017-09-28 [SCE]
      C95B 321B 61E8 8C18 09C4  F759 DDCA E044 F796 ECB0
uid           [ unknown] NVIDIA CORPORATION (Open Source Projects) <cudatools@nvidia.com>

pub   rsa4096 2016-06-24 [SC]
      AE09 FE4B BD22 3A84 B2CC  FCE3 F60F 4B3D 7FA2 AF80
uid           [ unknown] cudatools <cudatools@nvidia.com>
```

```
$ sudo apt-key del "C95B 321B 61E8 8C18 09C4  F759 DDCA E044 F796 ECB0"
OK
$ sudo apt-key del "AE09 FE4B BD22 3A84 B2CC  FCE3 F60F 4B3D 7FA2 AF80"
OK
```

## 2. Install NVIDIA driver. [Download page](https://www.nvidia.com/download/index.aspx?lang=en-us).

Since my driver is installed via runfile, the purge steps above will also remove my driver. I need to install it back. To choose driver version, follow the following rule:

>There is only one requirement, that one needs to satisfy in order to install multiple CUDA on the same machine. You need to have latest Nvidia driver that is required by the highest CUDA that you’re going to install. Usually it is a good idea to install precise driver that was used during the build of CUDA.


Download the driver [here](https://www.nvidia.com/download/index.aspx?lang=en-us), and execute the runfile:
```
$ sudo ./NVIDIA-Linux-x86_64_470.86.run
```

First time running the script received an error.

> ERROR: Nouveau kernel driver is currently in use by your system. ... For some distributions, Nouveau can be disabled by adding a file in the modprobe configuration directory. Would you like nvidia-installer to attempt to create this modprobe file for you? (Answer: Yes)
>
> Note if you later wish to re-enable Nouveau, you will need to delete these files: /etc/modprobe.d/nvidia-installer-disable-nouveau.conf

Disable the Nouveau and reboot the system.
```
$ reboot
```

After reboot there will be no GUI (because the graphics card's driver has been disabled!). Logged in remotely via ssh to execute the `.run` script:
```
$ sudo ./NVIDIA-Linux-x86_64_470.86.run
```
Followed the installation instructions to get the driver back to work. Immediately after the installation succeeds, Ubuntu GUI shows up.

Check driver configs:
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

## 3. Install the "CUDA stack"

What's in the "CUDA stack" (as of 2021.12.17):
    * CUDA
    * cuDNN
    * CUPTI
    * TensorRT (optional)

According to [kovalevskyi's guide](https://blog.kovalevskyi.com/multiple-version-of-cuda-libraries-on-the-same-machine-b9502d50ae77), it's better to use CUDA `runfile (local)` installers.

>I would strongly recommend use the installer script. First of all, it is agnostic to the version of the Linux that is used. Secondly, unlike some binary pre-build packages like deb file you can control where exactly CUDA library files will be installed.

The "CUDA stack" compatibility matrix can be checked [here](https://www.tensorflow.org/install/source#gpu).  
`cellassign` requires `tensorflow >= 2.1.0`. I've opted to use `2.4.0`for my build. For `tensorflow==2.4.0` I need `CUDA 11.0` and `cuDNN 8.0`.  
`Cell_BLAST` requires `tensorflow == 1.12.0` which depends on `CUDA 9.0` and `cuDNN 7`.  
Download the CUDA Toolkit installers [here](https://developer.nvidia.com/cuda-toolkit-archive).
Read the `Versioned Online Documentation` to understand the installation instructions, for example [this one](https://docs.nvidia.com/cuda/archive/11.0/).

**Pre-installation actions**:
```
$ lspci | grep -i nvidia  ## Verify a CUDA-capable GPU is available
$ uname -m && cat /etc/*release  ## Verify Linux Version Support
$ gcc --version  ## Verify that gcc is installed
```

### 3.1 CUDA-11.0 & cuDNN-8.0.4 for cellassign

Download **the `.run` file**.
```
$ wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda_11.0.2_450.51.05_linux.run
$ chmod u+x cuda_11.0.2_450.51.05_linux.run
$ sudo ./cuda_11.0.2_450.51.05_linux.run --silent --toolkit --tookitpath=/usr/local/cuda-11.0
```

Quoting [Kovalevskyi](https://blog.kovalevskyi.com/multiple-version-of-cuda-libraries-on-the-same-machine-b9502d50ae77):
>`--silent` — this will force installer to do everything in a silent mode without any interactive prompt. Really useful for the automation
>`--toolkit` — install only the toolkit, majority of users probably indeed need only toolkit
>`--toolkitpath` — this is where all the magic starts, each cuda that we’re going to install needs to be installed in its own separate folder, in our example CUDA9 is installed in /usr/local/cuda-9.0, therefore CUDA8 will be installed in /usr/local/cuda-8, CUDA9.1 can go to /usr/local/cuda-9.1 , etc

Create an NVIDIA account and download the cuDNN installers [here](https://developer.nvidia.cn/rdp/cudnn-archive). **Use `.tgz` file.**
For cuDNN, here are the **installation guide** for the [latest release](https://docs.nvidia.com/deeplearning/cudnn/index.html) or [archived relases](https://docs.nvidia.com/deeplearning/cudnn/archives/index.html). But we need to make a little hack.
```
$ tar -xzvf cudnn-11.0-linux-x64-v8.0.4.30.tgz
## Some hacks
$ sudo cp cuda/include/cudnn*.h /usr/local/cuda-11.0/include
$ sudo cp cuda/lib64/libcudnn* /usr/local/cuda-11.0/lib64
$ sudo chmod a+r /usr/local/cuda-11.0/include/cudnn*.h /usr/local/cuda-11.0/lib64/libcudnn*
```

### 3.2 CUDA-9.0 & cuDNN-7.6.5 for cellblast

Repeat the steps above to install `CUDA-9.0` & `cuDNN-7.6.5`.

For `CUDA 9.0`, gcc must be downgraded to `gcc-4.8` in order to compile during cuda runfile installtion. Do:
```
$ gcc -v
...
gcc version 7.5.0 (Ubuntu 7.5.0-3ubuntu1~18.04)
$ sudo apt-get install gcc-4.8
$ sudo update-alternatives --remove-all gcc
$ sudo apt-get install gcc
$ gcc -v
...
gcc version 4.8.5 (Ubuntu 4.8.5-4ubuntu8)
```

Install `CUDA-9.0` from runfile:
```
$ chmod u+x cuda_9.0.176_384.81_linux.run
$ sudo ./cuda_9.0.176_384.81_linux.run --silent --toolkit --toolkitpath=/usr/local/cuda-9.0
```

Install `cuDNN-7.6.5` from `.tgz`:
```
$ tar -xvzf cudnn-10.1-linux-x64-v7.6.5.32.tgz
$ sudo cp cuda/include/cudnn.h /usr/local/cuda-9.0/include
$ sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
$ sudo chmod a+r /usr/local/cuda-9.0/include/cudnn.h /usr/local/cuda-9.0/lib64/libcudnn*
```

According to the TensorRT [support matrix](https://docs.nvidia.com/deeplearning/tensorrt/archives/tensorrt-601/tensorrt-support-matrix/index.html), there is currently no TensorRT support for `CUDA 11.0` & `cuDNN 8.0.4`. For `CUDA 9.0` & `cuDNN 7.6.5`, `TensorRT 6.0.1` is availabl. However, TensorRT is optional, I haven't figured out exactly how to make a clean installation, so skip it for now.

For **post-installation actions**, i.e. PATH, LD_LIBRARY_PATH variables, we will have them setup in environment configurations.

### 3.3 Fix symlink

Make `/usr/local/cuda` point to the folder holding default cuda version, which I choose to be `CUDA-11.0`. This may be useful for other applications, for example `U-net`.
```
sudo rm /usr/local/cuda
sudo ln -s /usr/local/cuda-11.0 /usr/local/cuda
```

## 4. Setup Environment and Install Tools

Build environments for `cellassign` and `cellblast`.

### 4.1 cellassign

Create new environment:
```
$ conda create -n cellassign python=3.7
```

#### Setup shell scripts for `cellassign` conda environment

On activation of environment:
```
$ mkdir -p ~/miniconda3/envs/cellassign/etc/conda/activate.d
$ touch ~/miniconda3/envs/cellassign/etc/conda/activate.d/activate.sh
$ vim ~/miniconda3/envs/cellassign/etc/conda/activate.d/activate.sh
$ chmod +x ~/miniconda3/envs/cellassign/etc/conda/activate.d/activate.sh
```

Put these into `activate.sh`:
```
#!/bin/sh
ORIGINAL_PATH=$PATH
export PATH=/usr/local/cuda-11.0/bin:$PATH
ORIGINAL_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda-11.0/bin:/usr/local/cuda-11.0/lib64:/usr/local/cuda-11.0/extras/CUPTI/lib64:$LD_LIBRARY_PATH
```

On deactivation of environment:
```
$ mkdir -p ~/miniconda3/envs/cellassign/etc/conda/deactivate.d
$ touch ~/miniconda3/envs/cellassign/etc/conda/deactivate.d/deactivate.sh
$ vim ~/miniconda3/envs/cellassign/etc/conda/deactivate.d/deactivate.sh
$ chmod +x ~/miniconda3/envs/cellassign/etc/conda/deactivate.d/deactivate.sh
```

Put these into `deactivate.sh`:
```
#!/bin/sh
export PATH=$ORIGINAL_PATH
unset ORIGINAL_PATH
export LD_LIBRARY_PATH=$ORIGINAL_LD_LIBRARY_PATH
unset ORIGINAL_LD_LIBRARY_PATH
```

#### Install cellassign

The install instructions on `cellassign` [github page](https://github.com/Irrationone/cellassign) never worked. For a working build of `cellassign`, check out these threads:
    - [link1](https://github.com/Irrationone/cellassign/issues/92)
    - [link2](https://github.com/Irrationone/cellassign/issues/78#issuecomment-714901092)
    - [link3](https://github.com/Irrationone/cellassign/issues/94)

Note that the `tensorflow` R package is **NOT THE SAME** as the `tensorflow` python package. Supposedly it acts as a surrogate which talks to the core `tensorflow` python package. Both (the R and the python packages) are required in order for `cellassign` to work.

```
## In R
> # install.packages("tensorflow") ## DON'T DO THIS!
> devtools::install_github("rstudio/tensorflow@v2.4.0")  ## DO THIS!!
```

Though R `tensorflow` could be used to install the python package, I find it more convenient to install it directly into the conda environment from terminal.
```
## In terminal
$ conda activate cellassign
$ pip install --upgrade pip
$ pip install tensorflow==2.4.0
$ pip install tensorflow-gpu==2.4.0  ## Optional
$ pip install tensorflow-probability==0.12.0  ## Required!
```

Install `cellassign` R package.
```
## In R
> reticulate::use_condaenv("cellassign")
> tensorflow::tf_config()  ## Test installation
2021-12-02 14:24:33.313201: I tensorflow/stream_executor/platform/default/dso_loader.cc:49] Successfully opened dynamic library libcudart.so.11.0
Loaded Tensorflow version 2.4.0
TensorFlow v2.4.0 (~/miniconda3/envs/cellassign/lib/python3.7/site-packages/tensorflow)
Python v3.7 (~/miniconda3/envs/cellassign/bin/python)
> devtools::install_github("Irrationone/cellassign")
```

### 4.2 cellblast

Create new environment:
```
$ conda create -n cellblast python=3.6
```

#### Setup shell scripts for `cellblast` conda environment

Do the same for `cellblast` environment. On activation:
```
$ mkdir -p ~/miniconda3/envs/cellblast/etc/conda/activate.d
$ touch ~/miniconda3/envs/cellblast/etc/conda/activate.d/activate.sh
$ vim ~/miniconda3/envs/cellblast/etc/conda/activate.d/activate.sh
$ chmod +x ~/miniconda3/envs/cellblast/etc/conda/activate.d/activate.sh
```
Put in `activate.sh`:
```
#!/bin/sh
ORIGINAL_PATH=$PATH
export PATH=/usr/local/cuda-9.0/bin:$PATH
ORIGINAL_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/local/cuda-9.0/bin:/usr/local/cuda-9.0/lib64:/usr/local/cuda-9.0/extras/CUPTI/lib64:$LD_LIBRARY_PATH
```

On deactivation:
```
$ mkdir -p ~/miniconda3/envs/cellblast/etc/conda/deactivate.d
$ touch ~/miniconda3/envs/cellblast/etc/conda/deactivate.d/deactivate.sh
$ vim ~/miniconda3/envs/cellblast/etc/conda/deactivate.d/deactivate.sh
$ chmod +x ~/miniconda3/envs/cellblast/etc/conda/deactivate.d/deactivate.sh
```
Put in `deactivate.sh`:
```
#!/bin/sh
export PATH=$ORIGINAL_PATH
unset ORIGINAL_PATH
export LD_LIBRARY_PATH=$ORIGINAL_LD_LIBRARY_PATH
unset ORIGINAL_LD_LIBRARY_PATH
```

#### Install cellblast

```
$ pip install tensorflow-gpu==1.12  ## GPU & CPU
$ pip install tensorflow==1.12  ## CPU only
$ pip install Cell-BLAST
```

Check that installation succeeds:
```
$ python
> import tensorflow as tf
> tf.test.is_gpu_available()
...
True
> import Cell_BLAST as cb
```

<span style="color:gray">To build multiple Tensorflow versions, there will be various compatibilities requirements. Consider the followings:  
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
        The compatibilities between CUDA and cuDNN, as well as Tensorflow, python and gcc can be found [here](https://www.tensorflow.org/install/source#gpu). If you use different versions of Tensorflow on the same machine, like above for `cellassign` and `Cell BLAST`, you'll have to make multiple CUDA & cuDNN builts. For example, I've built on my machine `CUDA 9.0 & cuDNN 7.3.1` for `Cell BLAST` with `Tensorflow==1.12.0`, and `CUDA 11.0 & cuDNN 8.0.4` for `cellassign` with `Tensorflow==2.4.0`.</span>

