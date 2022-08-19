---
title: "Install Alphafold2 Docker Version (I)"
date: 2022-08-19T20:41:29+08:00
draft: false
mathjax: false
tags:        ["Machine Learning","Alphafold","Comp bio"]
categories:  ["Coding" ]
---

https://github.com/deepmind/alphafold

## First time setup

You will need a machine running Linux, AlphaFold does not support other operating systems.

The following steps are required in order to run AlphaFold:

1. Install [Docker](https://www.docker.com/).
    * Install [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) for GPU support.
    * Setup running [Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
2. Download genetic databases (see below).
3. Download model parameters (see below).
4. Check that AlphaFold will be able to use a GPU by running:
```
docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

---

**Documenting commands to keep track of what I've done.**

## Install `NVIDIA Container Toolkit`

Check [Platform requirements](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#platform-requirements)

GNU/Linux x86_64 with kernel version > 3.10
```
$ uname -r
5.4.0-124-generic
```

Docker >= 19.03
```
$ docker --version
Docker version 20.10.17, build 100c701
```

NVIDIA GPU with Architecture >= Kepler (or compute capability 3.0)
NVIDIA Linux drivers >= 418.81.07
```
$ nvidia-smi
Thu Aug 18 21:01:02 2022       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.141.03   Driver Version: 470.141.03   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro M4000        Off  | 00000000:02:00.0  On |                  N/A |
| 54%   56C    P8    18W / 120W |    630MiB /  8125MiB |     21%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|    0   N/A  N/A      2185      G   /usr/lib/xorg/Xorg                 59MiB |
|    0   N/A  N/A      3200      G   /usr/lib/xorg/Xorg                324MiB |
|    0   N/A  N/A      3461      G   /usr/bin/gnome-shell               32MiB |
|    0   N/A  N/A      4592      G   ...398429094371090466,131072      105MiB |
|    0   N/A  N/A      5271      G   /usr/lib/rstudio/bin/rstudio       74MiB |
+-----------------------------------------------------------------------------+
```

Alternatively, NVIDIA driver version can be obtained using the following command:
```
$ cat /proc/driver/nvidia/version 
NVRM version: NVIDIA UNIX x86_64 Kernel Module  470.141.03  Thu Jun 30 18:45:31 UTC 2022
GCC version:  gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1)
```

## [Docker](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker)

Following [this](https://docs.docker.com/engine/install/ubuntu/) instruction to install Docker Engine on Ubuntu.

### Uninstall old versions

```
$ sudo apt-get remove docker docker-engine docker.io containerd runc
```

*NOTE: It’s OK if `apt-get` reports that none of these packages are installed.*

### Installing using the repository (1st of 3 methods)

#### Set up the repository

1. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

```
$ sudo apt-get update
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:2 https://dl.google.com/linux/chrome/deb stable InRelease                 
Get:3 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]     
Hit:4 http://cn.archive.ubuntu.com/ubuntu focal InRelease
Get:5 http://cn.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:6 http://cn.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:7 http://cn.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [2,039 kB]
Get:8 http://cn.archive.ubuntu.com/ubuntu focal-updates/main i386 Packages [706 kB]
Get:9 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe i386 Packages [687 kB]
Get:10 http://cn.archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [939 kB]
Fetched 4,708 kB in 4s (1,056 kB/s)                       
Reading package lists... Done
```

```
$ sudo apt-get install \
> ca-certificates \
> curl \
> gnupg \
> lsb-release
Reading package lists... Done
Building dependency tree       
Reading state information... Done
lsb-release is already the newest version (11.1.0ubuntu2).
ca-certificates is already the newest version (20211016~20.04.1).
curl is already the newest version (7.68.0-1ubuntu2.12).
gnupg is already the newest version (2.2.19-3ubuntu2.2).
0 upgraded, 0 newly installed, 0 to remove and 5 not upgraded.
```

2. Add Docker’s official GPG key:

```
$ sudo mkdir -p /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

3. Set up the repository:

```
$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### Install Docker Engine

1. Update the `apt` package index, and install the *latest version* of Docker Engine, containerd, and Docker Compose:

```
$ sudo apt-get update
Get:1 https://download.docker.com/linux/ubuntu focal InRelease [57.7 kB]
Hit:2 https://dl.google.com/linux/chrome/deb stable InRelease                 
Get:3 https://download.docker.com/linux/ubuntu focal/stable amd64 Packages [17.7 kB]
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]     
Hit:5 http://cn.archive.ubuntu.com/ubuntu focal InRelease                     
Hit:6 http://cn.archive.ubuntu.com/ubuntu focal-updates InRelease             
Get:7 http://cn.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]  
Fetched 298 kB in 8s (35.7 kB/s)                                              
Reading package lists... Done
```

```
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
Reading package lists... Done
Building dependency tree       
Reading state information... Done
Suggested packages:
  aufs-tools cgroupfs-mount | cgroup-lite
The following NEW packages will be installed:
  docker-compose-plugin
The following packages will be upgraded:
  containerd.io docker-ce docker-ce-cli
3 upgraded, 1 newly installed, 0 to remove and 7 not upgraded.
Need to get 96.3 MB of archives.
After this operation, 26.6 MB of additional disk space will be used.
Get:1 https://download.docker.com/linux/ubuntu focal/stable amd64 containerd.io amd64 1.6.7-1 [28.1 MB]
Get:2 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce-cli amd64 5:20.10.17~3-0~ubuntu-focal [40.6 MB]
Get:3 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-ce amd64 5:20.10.17~3-0~ubuntu-focal [21.0 MB]
Get:4 https://download.docker.com/linux/ubuntu focal/stable amd64 docker-compose-plugin amd64 2.6.0~ubuntu-focal [6,560 kB]
Fetched 96.3 MB in 49s (1,957 kB/s)                                           
(Reading database ... 310677 files and directories currently installed.)
Preparing to unpack .../containerd.io_1.6.7-1_amd64.deb ...
Unpacking containerd.io (1.6.7-1) over (1.6.7-1) ...
Preparing to unpack .../docker-ce-cli_5%3a20.10.17~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce-cli (5:20.10.17~3-0~ubuntu-focal) over (5:20.10.17~3-0~ubuntu-bionic) ...
Preparing to unpack .../docker-ce_5%3a20.10.17~3-0~ubuntu-focal_amd64.deb ...
Unpacking docker-ce (5:20.10.17~3-0~ubuntu-focal) over (5:20.10.17~3-0~ubuntu-bionic) ...
Selecting previously unselected package docker-compose-plugin.
Preparing to unpack .../docker-compose-plugin_2.6.0~ubuntu-focal_amd64.deb ...
Unpacking docker-compose-plugin (2.6.0~ubuntu-focal) ...
Setting up containerd.io (1.6.7-1) ...
Setting up docker-compose-plugin (2.6.0~ubuntu-focal) ...
Setting up docker-ce-cli (5:20.10.17~3-0~ubuntu-focal) ...
Setting up docker-ce (5:20.10.17~3-0~ubuntu-focal) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for systemd (245.4-4ubuntu3.17) ...
```

2. Verify that Docker Engine is installed correctly by running the `hello-world` image.

```
$ sudo docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Already exists 
Digest: sha256:7d246653d0511db2a6b2e0436cfd0e52ac8c066000264b3ce63331ac66dca625
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

This command downloads a test image and runs it in a container. When the container runs, it prints a message and exits.

~~Docker Engine is installed and running. The `docker` group is created but no users are added to it. You need to use `sudo` to run Docker commands. Continue to [Linux postinstall](https://docs.docker.com/engine/install/linux-postinstall/) to allow non-privileged users to run Docker commands and for other optional configuration steps.~~ Already done.

```
$ groups
luolab adm cdrom sudo dip plugdev lpadmin sambashare docker
$ groups luolab
luolab : luolab adm cdrom sudo dip plugdev lpadmin sambashare docker
```

### [Setting up NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#setting-up-nvidia-container-toolkit)

Setup the package repository and the GPG key:

```
$ distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
>       && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
>       && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
>             sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
>             sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/$(ARCH) /
#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://nvidia.github.io/libnvidia-container/experimental/ubuntu18.04/$(ARCH) /
```

Install the `nvidia-docker2` package (and dependencies) after updating the package listing:

```
$ sudo apt-get update
Get:1 https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/amd64  InRelease [1,484 B]
Hit:2 https://download.docker.com/linux/ubuntu focal InRelease                                                                                                                                            
Hit:3 https://dl.google.com/linux/chrome/deb stable InRelease                                                                                                                                 
Get:4 http://security.ubuntu.com/ubuntu focal-security InRelease [114 kB]           
Get:5 https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/amd64  Packages [19.9 kB]               
Hit:6 http://cn.archive.ubuntu.com/ubuntu focal InRelease                                                               
Hit:7 http://cn.archive.ubuntu.com/ubuntu focal-updates InRelease                       
Get:8 http://cn.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Fetched 244 kB in 3s (93.6 kB/s)   
Reading package lists... Done
```

```
$ sudo apt-get install -y nvidia-docker2
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libnvidia-container-tools libnvidia-container1 nvidia-container-toolkit
The following NEW packages will be installed:
  libnvidia-container-tools libnvidia-container1 nvidia-container-toolkit nvidia-docker2
0 upgraded, 4 newly installed, 0 to remove and 7 not upgraded.
Need to get 2,917 kB of archives.
After this operation, 12.5 MB of additional disk space will be used.
Get:1 https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/amd64  libnvidia-container1 1.10.0-1 [926 kB]
Get:2 https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/amd64  libnvidia-container-tools 1.10.0-1 [24.1 kB]
Get:3 https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/amd64  nvidia-container-toolkit 1.10.0-1 [1,961 kB]
Get:4 https://nvidia.github.io/libnvidia-container/stable/ubuntu18.04/amd64  nvidia-docker2 2.11.0-1 [5,544 B]
Fetched 2,917 kB in 1s (2,853 kB/s)        
Selecting previously unselected package libnvidia-container1:amd64.
(Reading database ... 310680 files and directories currently installed.)
Preparing to unpack .../libnvidia-container1_1.10.0-1_amd64.deb ...
Unpacking libnvidia-container1:amd64 (1.10.0-1) ...
Selecting previously unselected package libnvidia-container-tools.
Preparing to unpack .../libnvidia-container-tools_1.10.0-1_amd64.deb ...
Unpacking libnvidia-container-tools (1.10.0-1) ...
Selecting previously unselected package nvidia-container-toolkit.
Preparing to unpack .../nvidia-container-toolkit_1.10.0-1_amd64.deb ...
Unpacking nvidia-container-toolkit (1.10.0-1) ...
Selecting previously unselected package nvidia-docker2.
Preparing to unpack .../nvidia-docker2_2.11.0-1_all.deb ...
Unpacking nvidia-docker2 (2.11.0-1) ...
Setting up libnvidia-container1:amd64 (1.10.0-1) ...
Setting up libnvidia-container-tools (1.10.0-1) ...
Setting up nvidia-container-toolkit (1.10.0-1) ...
Setting up nvidia-docker2 (2.11.0-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.9) ...
/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn_ops_infer.so.8 is not a symbolic link

/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn_ops_train.so.8 is not a symbolic link

/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn.so.8 is not a symbolic link

/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn_adv_infer.so.8 is not a symbolic link

/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn_adv_train.so.8 is not a symbolic link

/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn_cnn_infer.so.8 is not a symbolic link

/sbin/ldconfig.real: /usr/local/cuda-11.0/targets/x86_64-linux/lib/libcudnn_cnn_train.so.8 is not a symbolic link
```

<span style="color:orange">Do I have to worry about the symlinks warnings above?</span>

Restart the Docker daemon to complete the installation after setting the default runtime:

```
$ sudo systemctl restart docker
```

At this point, a working setup can be tested by running a base CUDA container:

```
$ sudo docker run --rm --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
Unable to find image 'nvidia/cuda:11.0.3-base-ubuntu20.04' locally
11.0.3-base-ubuntu20.04: Pulling from nvidia/cuda
d7bfe07ed847: Pull complete 
75eccf561042: Pull complete 
191419884744: Pull complete 
a17a942db7e1: Pull complete 
16156c70987f: Pull complete 
Digest: sha256:57455121f3393b7ed9e5a0bc2b046f57ee7187ea9ec562a7d17bf8c97174040d
Status: Downloaded newer image for nvidia/cuda:11.0.3-base-ubuntu20.04
Thu Aug 18 14:45:51 2022       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.141.03   Driver Version: 470.141.03   CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro M4000        Off  | 00000000:02:00.0  On |                  N/A |
| 56%   71C    P0    44W / 120W |    743MiB /  8125MiB |      4%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```

<span style="color:orange">The nvidia-docker does seem to work normally despite the symlink warnings.</span>

---

The Check command 4. listed in the `First time setup` section failed.

```
$ sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
Unable to find image 'nvidia/cuda:11.0-base' locally
docker: Error response from daemon: manifest for nvidia/cuda:11.0-base not found: manifest unknown: manifest unknown.
See 'docker run --help'.
```

The command in `READMD.md` is out-of-date, as in this [issue](https://github.com/NVIDIA/nvidia-docker/issues/1454).
