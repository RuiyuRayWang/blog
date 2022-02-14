---
title: "10X CellRanger 中测序饱和度的定义与计算（二）"
date: 2022-02-08T22:05:51+08:00
draft: true
mathjax: true
tags:        ["10X", "Single Cell Biology"]
categories:  ["Bioinformatics" ]
---

最近为了搭建单细胞测序上游分析的Pipeline，正在研究怎样对分析结果做质控（Pipeline详情移步<https://github.com/RuiyuRayWang/ScRNAseq_smkpipe_at_Luolab>）。参考了10X CellRanger官方网站中描述的对测序饱和度的定义和计算方法：

- [10X 官方文档：什么是测序饱和度？](https://kb.10xgenomics.com/hc/en-us/articles/115005062366-What-is-sequencing-saturation-)
- [10X 官方文档：测序饱和度怎样计算？](https://kb.10xgenomics.com/hc/en-us/articles/115003646912-How-is-sequencing-saturation-calculated-)

将用两篇文章记录这部分内容。

这篇文章是本系列文章的第二篇，将用10X官方文档中的示例数据来逐步解析代码实现过程。

***