---
title: "多重比较与P值矫正(一)：FWER"
date: 2022-02-27T22:57:36+08:00
draft: true
mathjax: false
tags:        ["News","Politics"]
categories:  ["杂谈" ]
---

随着高通量技术逐渐发展完善，现代生物学的组学实验已经可以实现同时测量成百上千甚至上万个变量（variables）。如一次转录组实验可以得到10000-20000个基因的转录本丰度，蛋白组实验可以得到几千个有效蛋白肽段的丰度，磷酸化蛋白组可以得到~10000个磷酸化位点的肽段丰度。一组实验中我们往往会设置至少两个条件，而