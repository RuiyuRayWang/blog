---
title: "10X CellRanger 中测序饱和度的定义与计算（一）"
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

这篇文章是本系列文章的第一篇，将对相关概念和计算公式的定义进行解读。

***

### 一、`测序饱和度` 和 `文库复杂度`

关于测序饱和度的定义，引用10X文档中的说明：

>**Question:** What is sequencing saturation?  
>**Answer:** Sequencing saturation is a measure of ***the fraction of library complexity*** that was sequenced in a given experiment. The ***inverse*** of the sequencing saturation can be interpreted as the number of additional reads it would take to detect a new transcript.

这两句话言简而意赅，点明了测序饱和度(sequencing saturation)与文库复杂度(library complexity)之间的关系。

[library complexity (文库复杂度)](https://gatk.broadinstitute.org/hc/en-us/articles/360037591931-EstimateLibraryComplexity-Picard-)，指的是一个测序文库中非冗余的DNA片段的数量（the number of unique DNA fragments present in a given library）。  
**`测序饱和度`表征了当前的测序数据中测出了多少`文库复杂度`。**

从逆命题的角度来看待这个问题：发明一个新名词`“测序不饱和度”`，则`“测序不饱和度”`可以定义为 *再多测序多少个Reads就可以检测到一个全新的转录本[^1]*。  
换句话说，**如果我们只需要再测很少的Reads就可以得到一个全新的转录本，说明这个文库“测序不饱和”；反之，如果需要再测很多Reads才能得到一个全新的转录本，说明这个文库“测序饱和”。**

其实我们还可以从**冗余信息**的角度来理解这个问题：  
对于一个文库，**如果仅再测很少Reads就检测到了全新的转录本，说明当前数据还远未挖掘出文库中的大部分信息，数据的信息冗余程度比较低，测序不饱和；**  
而反过来，**如果需要再测很多Reads才能检测到全新的转录本，说明当前数据对文库中包含的信息挖掘得比较充分，数据的信息冗余程度比较高，测序接近饱和。**  

所以本质上，测序饱和度可以间接地由**信息冗余程度**进行度量。  
数据信息冗余度越高，测序饱和度越高；  
数据信息冗余度越低，测序饱和度越低。

从实际角度出发，我们有时候**并不希望信息冗余度**太高。因为冗余信息越多，浪费的资源越多。所以有些研究不会将 测序饱和度 的目标阈值设定到接近饱和（>90%），而是测到70%左右就收工了。  
在受经费条件等因素限制的情况下这是一种合理策略。

***

### 二、影响测序饱和度的因素

在单细胞测序中，测序饱和度主要由两个因素决定：

* 文库复杂度(Biological Complxity)：
    >Different cell types will have different amounts of RNA and thus will differ in the total number of different transcripts in the final library (also known as library complexity). The figure below illustrates the median number of genes recovered from different cell types. As sequencing depth increases, more genes are detected, but this reaches saturation at different sequencing depths depending on cell type.

    文库复杂度一般由生物学样本的复杂程度决定。而生物学样本的复杂度又由多个因素，如细胞异质性(Cell Heterogeneity)、转录组RNA含量、细胞质量、细胞数等共同决定。~~越是简单均一的系统，生物复杂程度越低。~~  
    下图中，原代分离的PBMC(外周血单核细胞)和E18小鼠神经元细胞RNA含量较低（？）[^2]，因此迅速达到测序饱和；而培养的永生细胞3T3和HEK293T的RNA含量比较高（？）[^2]，测序不容易达到饱和。同样作为永生细胞，3T3细胞系的转录组比HEK293T细胞系的转录组复杂，因此相比之下不容易测序饱和。
* 测序深度(Sequencing Depth)
    >Sequencing depth also affects sequencing saturation; generally, the more sequencing reads, the more additional unique transcripts you can detect. However, this is limited by the library complexity.

    即每个文库实际测到的Reads数。在控制其他条件不变的情况下，一般来讲测序深度越高测序饱和度越高，直观上这很容易理解。

![Figure 1](https://kb.10xgenomics.com/hc/article_attachments/115016412246/SingleCell_GeneRecovery_by_SeqDepth_combined.png#middle)

上面的内容可以总结在一个公式中：

$$测序饱和度\propto\frac{测序深度}{文库复杂度}$$

如果一个样本的生物学成分比较复杂，那送样时就可以提前计划适当提高测序深度；如果测完发现测序饱和度还是不够，那就对文库进行加测（提高测序深度）。

***

### 三、测序饱和度的计算

10X官方文档给出了测序饱和度计算公式：

>$$Sequencing\ Saturation = 1 - \frac{n_{deduped\ reads}}{n_{reads}}$$  
>where  
>$n_{deduped\ reads}$ = Number of unique (valid cell-barcode, valid UMI, gene) combinations among confidently mapped reads  
>$n_{reads}$ = Total number of confidently mapped, valid cell-barcode, valid UMI reads  
>.  
>Note that the numerator of the fraction is $n_{deduped\ reads}$, not the non-unique reads that are mentioned in the definition. $n_{deduped\ reads}$ is a degree of uniqueness, not a degree of duplication/saturation. Therefore we take the complement of $n_{deduped\ reads}/n_{reads}$ to measure saturation.

即

$$测序饱和度=1-\frac{去重后Reads数}{总Reads数}=\frac{重复Reads数}{总Reads数}$$

注意重复Reads是通过Barcode和UMI定义的。两个Reads出现同样的Barcode + UMI组合，就将其中一个定义为重复；三个Reads出现同样的Barcode + UMI组合，其中两个定义为重复，剩下一个定义为去重后Read。

从这个公式也可以看出，重复Reads数越高，冗余信息越多，测序饱和度也越高。

该公式只计算了一个数值，代表某次测序fastq文件整个数据的测序饱和度。如果要实现10X CellRanger输出web_summary的中饱和度曲线的绘制，感觉还是比较麻烦的。理论上，需要对fastq文件做不同水平的降采样，再分别算测序饱和度。  
目前还不清楚CellRanger是怎么实现一次alignment过程中输出不同测序深度下的测序饱和度的。

[^1]: 全新的转录本，在10X官方文档的语境下，指的是一个全新的 Barcode + UMI 组合（i.e. a previously unobserved, unique combination of valid cell-barcode and valid UMI）
[^2]: 直觉上这并不 make sense。原代细胞有较高的细胞异质性，如果其他条件相同，理应更难达到测序饱和。猜测也许是因为原代细胞分离下来细胞状态不如永生细胞，因此导致文库质量不佳。