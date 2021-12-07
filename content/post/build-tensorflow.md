---
title:       "Building System & Environment Support for Tensorflow on Ubuntu"
subtitle:    "First Dive into Deep Learning"
description: ""
date:        2021-12-05T22:57:25+08:00
author:      Ruiyu Wang
image:       ""
tags:        ["Tensorflow", "Ubuntu", "Deep Learning"]
categories:  ["Tech" ]
---

As promised, I will write about my experience with installation of tensorflow. The process looks daunting at first, but once you're familiar with the process, it's nothing more than a couple lines of sudo commands.

### Compatibility

Before start, make sure to check compatibilities between the tools and packages that you'll be building with. Take the following things into consideration:

    - Ubuntu
        16.04? 18.04? or others? Although NVIDIA explicitly specified different build packages for each version, sometimes you don't have to strictly follow them. I've had success with installing CUDA 9.0 for Ubuntu 16.04 over a 18.04 system with no obvious issue (since there is no CUDA 9.0 release for 18.04). Experiment yourself!
    - Tensorflow
        Tensorflow `MAJOR` versions can have a big difference. Usually, packages built under Tensorflow 1 will not work with Tensorflow 2, and vice versa. Be sure to check installation specifications of the package you'll be using and install the corresponding Tensorflow versions. **Remember to build dedicated environments** for each package with Tensorflow version required. For example, `cellassign` requires `Tensorflow>=2.1.0`, but `Cell BLAST` requires `Tensorflow==1.12.0`. In such case, I have to create two environments, one with `Tensorflow>=2.1.0` and `cellassign` installed, and the other with `Tensorflow==1.12.0` and `Cell BLAST` installed.  
        The GPU specificity does not seem to be a big issue. You could always install the same version of `tensorflow-gpu`, provided that that version of `tensorflow` can be built successfully. Just make sure your machine has a supporting GPU or there's no point in installing it.
    - GCC
        I did not run into any issue with gcc on my machine. I think most recently built Ubuntu systems carry a legit gcc version with it. In the installation procedures, there's one step that explicitly checks gcc version. If gcc has a trouble, you'll find it there.
    - CUDA
    - cuDNN
        Compatibilities between CUDA and cuDNN, as well as Tensorflow, python and gcc can be found [here](https://www.tensorflow.org/install/source#gpu). If you use different versions of Tensorflow on the same machine, like above for `cellassign` and `Cell BLAST`, you'll have to make multiple CUDA & cuDNN builts. For example, I've built on my machine `CUDA 9.0 & cuDNN 7.3.1` for `Cell BLAST` with `Tensorflow==1.12.0`, and `CUDA 11.0 & cuDNN 8.0.4` for `cellassign` with `Tensorflow==2.4.0`.

### Removing previous installations

In case