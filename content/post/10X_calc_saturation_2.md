---
title: "10X CellRanger 中测序饱和度的定义与计算（二）"
date: 2022-02-08T22:05:51+08:00
draft: false
mathjax: true
tags:        ["10X", "Single Cell Biology"]
categories:  ["Bioinformatics" ]
---

最近为了搭建单细胞测序上游分析的Pipeline，正在研究怎样对分析结果做质控（Pipeline详情移步<https://github.com/RuiyuRayWang/ScRNAseq_smkpipe_at_Luolab>）。参考了10X CellRanger官方网站中描述的对测序饱和度的定义和计算方法：

- [10X 官方文档：什么是测序饱和度？](https://kb.10xgenomics.com/hc/en-us/articles/115005062366-What-is-sequencing-saturation-)
- [10X 官方文档：测序饱和度怎样计算？](https://kb.10xgenomics.com/hc/en-us/articles/115003646912-How-is-sequencing-saturation-calculated-)

将用两篇文章记录这部分内容。

**注意：本系列文章的参考来源均为10X官方公开的信息。**

这篇文章是本系列文章的第二篇，将利用10X官方文档中的示例数据来展示测序饱和度计算的代码复现。

***

下载数据：  

>Uses dataset at <https://support.10xgenomics.com/single-cell-gene-expression/datasets/3.0.0/pbmc_1k_v3>, where the web summary report gives a sequencing saturation value of 0.7085123.​

[web_summary.html](https://cf.10xgenomics.com/samples/cell-exp/3.0.0/pbmc_1k_v3/pbmc_1k_v3_web_summary.html)

***

计算公式：

>The sequencing saturation calculation below matches the 0.7085123 sequencing saturation given in the web summary report.

```
unique_confidently_mapped_reads = 10,196,940
duplicate_reads = 24,785,461

x = 1 - (unique_confidently_mapped_reads/(unique_confidently_mapped_reads + duplicate_reads))
x = 1 - (10,196,940/(10,196,940 + 24,785,461))
x = 1 - (10,196,940/34,982,401)
x = 1 - 0.2148771
x = 0.70851229
```

***

`web_summary.html`中并没有直接给出`unique_configdently_mapped_reads`和`duplicate_reads`具体是多少。实际上这两个参数都是可以从bam中抓取的。具体抓取方法在官方文档中也已经给出。我这里介绍另一种有点hacky的方法，可以从结果反推算出`unique_configdently_mapped_reads`是多少。从这个方法我们可以一窥10X输出的文件结构，也可以加深我们对数据含义的理解。

下载`Feature / cell matrix (raw)`，得到文件`pbmc_1k_v3_raw_feature_bc_matrix.tar.gz`，将其解压：
```
$ tar -xvzf pbmc_1k_v3_raw_feature_bc_matrix.tar.gz
```
得到`raw_feature_bc_matrix/`文件夹，进入后将其中`matrix.mtx.gz`文件进一步解压出来：
```
$ cd raw_feature_bc_matrix
$ gunzip -k matrix.mtx.gz
$ head matrix.mtx
%%MatrixMarket matrix coordinate integer general
%metadata_json: {"format_version": 2, "software_version": "3.0.0"}
33538 6794880 3394796
1815 9 1
4027 9 1
6626 9 1
17060 9 1
18003 9 1
21000 9 1
30469 9 1
```
这个文件起始有两行header，随后是一个有三列的表，每列由空格分隔。这个表相当于一个DataFrame。  
第一列表示基因，第二列表示细胞，第三列表示该基因在该细胞中Read的count数（和`umi_tools count`的输出一模一样）。

将前两行的header去掉，把表读到R里：
```
$ tail +3 matrix.mtx > tmp
$ mv tmp matrix.mtx
$ R
> raw <- read.table("matrix.mtx", sep=" ", header=T)
> head(raw)
  X33538 X6794880 X3394796
1   1815        9        1
2   4027        9        1
3   6626        9        1
4  17060        9        1
5  18003        9        1
6  21000        9        1
```

对第三列求和，这本质上相当于deduplicate之后数据里剩下的reads数：
```
> sum(raw$X3394796)
[1] 10196940
```

会发现这个数值就是`unique_confidently_mapped_reads`。

上面介绍的方法相当于是“逆向工程”反推出`unique_confidently_mapped_reads`是多少，是一个比较hacky的办法。

10X官方文档中是正儿八经从bam文件正向算的：

>The unique_confidently_mapped_reads are the reads with xf tag value 25, as described on https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/output/bam. The bits are 1, 8, 16. You can obtain theunique_confidently_mapped_reads by parsing the BAM like so.
```
samtools view pbmc_1k_v3_possorted_genome_bam.bam | grep 'xf:i:25' | wc -l
```
可以看到，CellRanger在做Alignment时会给`unique_confidently_mapped_reads`打上一个tag`xf=25`。这里是用samtools在bam文件中抓取这些tag来计算`unique_confidently_mapped_reads`的。

***

至于`duplicate_reads`，在10X给出的数据中似乎只能从bam文件抓取。

>The duplicate_reads are those marked with the sam flag 0x400 as explained on https://broadinstitute.github.io/picard/explain-flags.html and can be obtained by running samtools flagstat.
```
samtools flagstat pbmc_1k_v3_possorted_genome_bam.bam
76920923 + 0 in total (QC-passed reads + QC-failed reads)
10319036 + 0 secondary
0 + 0 supplementary
24785461 + 0 duplicates
73840063 + 0 mapped (95.99% : N/A)
...
```

>All of these samflag 0x400 reads have an xf tag value of 17, which consist of bits 1 and 16. This also means these reads do not have the xf bit of 8, which mark representative reads from a group of duplicates. The converse isn't true though. The xf17 consist mostly of samflag 0x400 duplicate reads but also of samflag nonduplicate reads.

而如果使用[`ScRNAseq_smkpipe_at_Luolab`](https://github.com/RuiyuRayWang/ScRNAseq_smkpipe_at_Luolab)的protocol，则可以从`umi_tools`或者`featureCounts`输出的log文件抓取。

***

有了`unique_configdently_mapped_reads`和`duplicate_reads`，测序饱和度就可以直接计算了：
```
unique_confidently_mapped_reads = 10,196,940
duplicate_reads = 24,785,461

x = 1 - (unique_confidently_mapped_reads/(unique_confidently_mapped_reads + duplicate_reads))
x = 1 - (10,196,940/(10,196,940 + 24,785,461))
x = 1 - (10,196,940/34,982,401)
x = 1 - 0.2148771
x = 0.70851229
```

这里只是计算了fastq文件全部分析完后的`测序饱和度`。如果要绘制测序饱和度曲线，则要在不同降采样水平的fastq上逐个计算。  
如果利用10X给出的从bam文件抓取信息的方法，我们就可以在bam上做随机降采样，然后抓取数值，计算每个测序深度水平的`测序饱和度`了。
