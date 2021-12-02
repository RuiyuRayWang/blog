---
title:       "My First Post"
date:        2021-11-23T19:59:57+08:00
draft:       false
author:      Ruiyu Wang
tags:        []
categories:  ["Tech" ]
type:        post
---

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

To add new contents to the blog, open up a terminal and navigate to the `/blog` directory and type:
```
hugo new content/post/[new-post-name].md
```
The newly created markdown should assume a pre-defined format (headers, etc.). Edit the post contents and then set `draft` to `false`, the post will be updated marked and recognized the next time `hugo -D` is invoked.

Before pushing to github remote site, check locally how the update looks, do:
```
hugo server -D
```
and the newly generated site can be viewed at `http://localhost:1313/`
