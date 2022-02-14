---
title:       "Hugo blog，新主题，新开始"
date:        2021-11-23T19:59:57+08:00
draft:       false
author:      Ruiyu Wang
tags:        []
categories:  ["Hugo" ]
---

2022-02-28更新：

去年年底拿Hugo搭了一个博客，但用了没几日就没有动力再写了。我反思了一下可能主要有两个原因，总结一下：

1. 长篇累牍使用英文撰写，逼格定调得太高。造成的后果是可读性差，效率又低。
   今后还是老老实实用母语行文，必要时候可以加入洋文。
2. 选用的主题（hugo-theme-cleanwhite by Huabing）过于花里胡哨。
   每次翻阅过去的记录都感觉头晕目眩，遂挑了一个简约的主题重新搭了博客。

业精于勤而荒于嬉。今后还要再接再厉，也许做不到笔耕不辍，但至少也应该保持三天两头写点东西。

这里就先记录下我是如何从hugo-theme-cleanwhite跳到新的主题Diary的。

新主题Diary地址：(https://themes.gohugo.io/themes/hugo-theme-diary/)

***

下面是具体步骤。

如链接教程中的Quick Start所述，先用`git submodule`把Repo部署到本地的`blog/themes`目录下：

```
cd my_hugo_site/blog
git submodule add https://github.com/AmazingRise/hugo-theme-diary.git themes/diary
```

接下来可以跳过教程Quick Start中的步骤2、3。  
直接到`blog`目录下，用[这个模板](https://github.com/AmazingRise/hugo-theme-diary/blob/1.2.1/exampleSite/config.toml)，替换`config.toml`文件中的内容。

由于最初将这个Hugo site部署到github时参考了[这篇推文](https://blog.csdn.net/kutawei/article/details/105421545)，需要对`config.toml`进行修改，以满足本地的目录结构。

修改了下面几个参数：

```
baseURL = "/"
title = "Karmotrine Dream"
copyright = ""
theme = "diary"
subtitle = ""
```

添加下面这个参数，使`hugo -D`命令生成的网页推到`public/`目录下：

```
publishDir = "../public"
```

删除原来`public/`目录中所有内容（这些是旧theme生成的文件）。

最后，修改`deploy.sh`中的命令，使用diary作为theme来生成新的site：

```
hugo -D -t diary # or `hugo -D` if no theme is specified
```

And Voila!  
Hugo博客的theme变为Diary了！

***

最后写一下怎样在本地编辑、预览博客内容。

首先`cd`到`blog/`目录下，用`hugo new`建新的post文件：
```
cd my_hugo_site/blog
hugo new content/post/[new-post-name].md
```

在新的博客写好后，可用下面的指令在本地预览：
```
hugo server -D
```
若预览中发现错误，务必及时纠正。

确保无误后，用`deploy.sh`脚本推送到github上即可：
```
./deploy.sh
```

这样就大功告成了！

***

(以下内容是旧时的博客，写于2021-11-23)

Hosting my first Blog with Hugo on Github!

For a starter, I'll document in this post how the blog is managed and used.
I've setup the site by referring to [here](https://blog.csdn.net/kutawei/article/details/105421545), [here](https://zhuanlan.zhihu.com/p/150095964), and [here](https://gohugo.io/getting-started/quick-start/).

The first link is particularly useful. I've adopted its file structure for setting up privately managed (`/blog`) and public sites (`/public`).
Critically, the `/public` repo must be created with the following convention: https://github.com/RuiyuRayWang/ruiyuraywang.github.io
Everytime contents in `/blog` is updated, run `hugo -D` to generate new site to `/public` and push `/public` to github accordingly.

For automatic regeneration of the static site, a shell script is given (`./deploy.h`). After editing contents in `/blog`, simply do
```
./deploy.sh
```
and the static sites will be updated.

To add new contents to the blog, open up a terminal and navigate to the `blog/` directory and type:
```
hugo new content/post/[new-post-name].md
```
The newly created markdown should assume a pre-defined format (headers, etc.). Edit the post contents and then set `draft` to `false`, the post will be updated marked and recognized the next time `hugo -D` is invoked.

Before pushing to github remote site, check locally how the update looks, do:
```
hugo server -D
```
and the newly generated site can be viewed at `http://localhost:1313/`
