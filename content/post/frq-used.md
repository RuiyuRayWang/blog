---
title:       "装机"
date:        2021-12-02T17:41:03+08:00
draft:       true
mathjax: false
tags:        []
categories:  ["Coding" ]
---



## Mac (iOS)
Reconfiguring conda env.

```
$ rm -rf miniconda3/
$ curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh  # Download miniconda
$ shasum -a 256 Miniconda3-latest-MacOSX-x86_64.sh  # verify installer hashes
$ bash Miniconda3-latest-MacOSX-x86_64.sh
```

`base` environment.
```
(base) conda install mamba -n base -c conda-forge  # installing `mamba` to `base` allows other envs to use it
```

Single Cell Biology.
```
(base) $ conda create -n SCBiology python=3.9
(base) $ conda activate SCBiology
(SCBiology) $ conda install -c conda-forge scanpy python-igraph leidenalg
(SCBiology) $ pip install -U scvelo
(SCBiology) $ conda deactivate
```

PyTorch.
```
(base) $ conda create -n pytorch python=3.9
(base) $ conda activate pytorch
(pytorch) $ conda install pandas
(pytorch) $ conda install matplotlib
(pytorch) $ conda install pytorch torchvision torchaudio -c pytorch
(pytorch) $ conda install ipykernel  # configure ipython kernel
(pytorch) $ conda deactivate
```

Jupyter lab.
```
(base) $ conda create -n jupyter python=3.9
(base) $ mamba install jupyterlab -n jupyter -c conda-forge
(base) $ conda activate jupyter
(jupyter) $ pip install notebook
(jupyter) $ pip install hugo_jupyter
(jupyter) $ conda deactivate
```

Configure ipython kernels
```
(base) $ conda activate jupyter
(jupyter) $ jupyter kernelspec list
[ListKernelSpecs] WARNING | Kernel Provisioning: The 'local-provisioner' is not found.  This is likely due to the presence of multiple jupyter_client distributions and a previous distribution is being used as the source for entrypoints - which does not include 'local-provisioner'.  That distribution should be removed such that only the version-appropriate distribution remains (version >= 7).  Until then, a 'local-provisioner' entrypoint will be automatically constructed and used.
The candidate distribution locations are: ['/Users/Ray/miniconda3/envs/jupyter/lib/python3.9/site-packages/jupyter_client-7.3.2.dist-info']
Available kernels:
  python3    /Users/Ray/miniconda3/envs/jupyter/share/jupyter/kernels/python3
  pytorch    /usr/local/share/jupyter/kernels/pytorch
```

[Fix](https://discourse.jupyter.org/t/kernel-python-3-is-referencing-a-kernel-provisioner-local-provisioner-that-is-not-available-ensure-the-appropriate-package-has-been-installed-and-retry/10436/3):
```
(jupyter) $ conda install --force-reinstall jupyter_client
```

To remove a deprecated kernel.
```
(jupyter) $ jupyter kernelspec remove pytorch
(pytroch)$ jupyter kernelspec list
Available kernels:
  python3    /Users/Ray/miniconda3/envs/pytorch/share/jupyter/kernels/python3
```

To add a new kernel, switch to the conda env with which the kernel will be created and install `ipykernel`.
```
(jupyter) $ conda install -n pytorch ipykernel
(jupyter) $ conda activate pytorch
(pytroch) $ python -m ipykernel install --name pytorch
Installed kernelspec pytorch in /usr/local/share/jupyter/kernels/pytorch
(pytroch)$ jupyter kernelspec list
Available kernels:
  python3    /Users/Ray/miniconda3/envs/pytorch/share/jupyter/kernels/python3
  pytorch    /usr/local/share/jupyter/kernels/pytorch
```

Summary:
```
# 为jupyter添加kernel
python -m ipykernel install  --name kernelname
 
# 删除已存在的kernel
jupyter kernelspec remove kernelname
 
# 查看kernel列表
jupyter kernelspec list
```

1. bash tools
    - brew
    - tree
2. softwares
    - miniconda
    - R
    - Rstudio
    - jupyter-lab / jupyter notebook


## Ubuntu
1. Basic Bioinformatics
    - samtools
    - STAR
    - IGV
2. RNAseq
    - Salmon
3. Single Cell Biology
    - umi_tools
    - subread
    - velocyto

# Conda envs

## pytorch (Deep Learning)
    - NVIDIA driver (if using GPU)
    - numpy
    - pandas
    - scipy
    - matplotlib
    - pytorch

# Single cell biology
1. R
```
## tidyverse
install.packages("tidyverse")

## Bioconductor
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.15")  ## Specify version explicitly

## devtools
install.packages("devtools")

## Seurat and relatives
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("mojaveazure/seurat-disk")
install.packages("Seurat")
BiocManager::install("scater")
BiocManager::install("MAST")
setRepositories(ind=1:3)
install.packages("Signac")
install.packages("tidyseurat")

## RNAseq bundle
BiocManager::install("DESeq2")
BiocManager::install("tximeta")

```

```
install.packages('rmarkdown')
install.packages("knitr", dependencies = TRUE)
install.packages("rstudioapi")
install.packages('extrafont')
```

```
## Drop-utils
BiocManager::install("DropletUtils")

## Decontamination
BiocManager::install("celda")  ## DecontX
BiocManager::install("singleCellTK")  ## suggested by Decontx
install.packages("SoupX")  ## SoupX

## Doublet removal
remotes::install_github('chris-mcginnis-ucsf/DoubletFinder')

## clusterProfiler
BiocManager::install("clusterProfiler")

## Augur
devtools::install_github("const-ae/sparseMatrixStats")
devtools::install_github("neurorestore/Augur")

## ComplexHeatmap
BiocManager::install("ComplexHeatmap")

## pheatmap
install.packages("pheatmap")

## CellChat
install.packages('NMF')
devtools::install_github("jokergoo/circlize")
devtools::install_github("sqjin/CellChat")

## Org database
BiocManager::install("org.Hs.eg.db")
BiocManager::install("org.Mm.eg.db")
```

```
## Plotting engines

## Venn Plot
install.packages("UpSetR")
install.packages("VennDiagram")
install.packages("nVennR")
```

2. python
    - anndata
    - scanpy
    - scvelo
    - loompy