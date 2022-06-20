---
title: "Debug: celda installation failed"
date: 2022-06-20T16:07:43+08:00
draft: true
mathjax: false
tags:        ["R", "Single Cell Biology"]
categories:  ["Coding" ]
---

While installing `celda`:

```
BiocManager::install('celda')

...

Error: package or namespace load failed for ‘magick’ in dyn.load(file, DLLpath = DLLpath, ...):
 unable to load shared object '/home/luolab/R/x86_64-pc-linux-gnu-library/4.2/magick/libs/magick.so':
  ... no such file or directory
```

I'm running on Ubuntu 20.04 LTS.

Installing imagemagick `Magick++` library resolved the issue. See <https://github.com/ropensci/magick>

```
$ sudo apt-get install -y libmagick++-dev
```

```
# Everything works fine
BiocManager::install('celda')
```