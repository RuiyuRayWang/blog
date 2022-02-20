---
title:       "咋地，你也想整点计算生物学玩玩？"
date:        2021-12-02T16:49:27+08:00
tags:        ["Paper", "Comp bio", "Bioinformatics"]
categories:  ["Bioinformatics"]
author:      Ruiyu Wang
draft:       false
type:        post
---

Nick Loman和Mick Watson在2013年写了一篇Commentary发在NBT上，题为 [*So you want to be a computational biologist?*](https://doi.org/10.1038/nbt.2740)

文章短小精悍，非常精彩。很多细节能够看出作者是实打实的计算生物学从业者，给出了很多中肯的建议。对于所有有志于从事计算生物学、生物信息学的人，这篇文章值得反复阅读。

几句题外话：Nick Loman 79年生人，年轻时与其兄弟Rupert Loman沉迷电子游戏，后来二人发现比起打游戏他们更擅长组织管理，于是合伙创立了公司Eurogamer Network，后者逐渐发展为欧洲最大的电子媒体之一Gamer Network。  
2004年，Nick步入大学，跳出Eurogamer，一头扎进生命医学领域，开始了自己的学术生涯。这哥们后来科研做得风生水起，h-index高达68，现任伯明翰大学教授（2017年转正 #Twitter）~Research Fellow（居然还不是教授...）~。2018年，Gamer Network被出版巨头Reed收购，说不定Nick利用自己学者身份从中斡旋了一番（没有实锤，我猜的）。

Recently I ran into this wonderful [article](https://doi.org/10.1038/nbt.2740) published in Nature Biotechnology written by Nick Loman and Mick Watson, about how to become a computational biologist. The article is so brilliant and I thought I should dedicate my (actual) first post to write about it.

I'll only put here excerptions of the article that I feel excited about. For full article, refer to the links above.

***

>The term ‘computational biologist’ can encompass several roles, including data analyst, data curator, database developer, statistician, mathematical modeler, bioinformatician, software developer, ontologist — and many more. What’s clear is that computers are now essential components of modern biological research, and scientists are being asked to adopt new skills in computational biology and master new terminology. Whether you’re a student, a professor or somewhere in between, if you increasingly find that computational analysis is important to your research, follow the advice below and start along the road towards becoming a computational biologist!

## 1. Understand your goals and choose appropriate methods

>Key to good computational biology is the selection and use of appropriate software. Before you can usefully interpret the output of a piece of software, you must understand what the software is doing. ... That doesn’t mean you need to read through each line of source code, but you should have a grasp of the concepts.

There is always more tools to choose from than we can actually use. Choose tools wisely. Define your work with words accurately and search carefully. Use well-maintained tools. Use tools with higher user base. High popularity of a tool usually indicates good maintenance. If you decide to use a less popular tool, know the risk: you may experience more bugs or even criticisms during publication.

Understand what the tool is doing, but don't dive into the technical details too early. Having a good grasp of what the inputs and outputs are is usually enough for doing the job.

Critically, one must also have a good understanding of the biological question at hand. No tool fits all problems. Under different scenarios, one may have to look for different tools to solve the problem.

## 2. Set traps for your own scripts and other people’s

>How do you know your script, software or pipe- line is working? Computers will happily output results for the most bizarre of input data, and the absence of an error message is not an indica- tion of success.

Write tests!

Okay I concede, I don't like writing tests, but I have my own ways to check my codes. If you like me, at least make your codes output some intermediate steps, and design a "protocol" to manually check with them to ensure that the codes worked properly.

## 3. You’re a scientist, not a programmer(!!!)

>The perfect is the enemy of the good. Remember you are a scientist and the quality of your research is what is important, **NOT** how pretty your source code looks. Perfectly written, extensively documented, elegant code that gets the answer wrong is not as useful as a basic script that gets it right. Having said that, once you’re sure your core algorithm works, spend time making it elegant and documenting how to use it. Use your biological knowledge as much as possible—that’s what makes you a computational biologist.

**This is THE most important take home message.**

The first rule of being a computational biologicst, is that you should make the center of your work biology, not programming.

## 4. Use Version Control Software

>Versioning will help you track changes to your code, maintain multiple versions and to work collaboratively with others. Using a standard tool, such as Git or Subversion, you will also be able to publish your code easily. Be nice to your future self. A few well-placed README files explaining the choices you made and why you made them will be a boon in months or years when you return to a project. Document your code and scripts so that you understand what they do. When you come to publish your work, try publishing the scripts and methods you used to generate your results so that others can reproduce them. Also consider keeping a digital laboratory notebook to document your analyses as you perform them. Repositories, such as Github, are ideal for this and also help you maintain copies of the repository to serve as off-site backups.

Learn to use Git! 

It's extremely powerful and useful.

If you haven't already, sign up for github.

With github, you can setup a personal blog just like I do, and even use it as a digital laboratory notebook.

## 5. Pipelineitis is a nasty disease(!!)

>Pipelines are great for running exactly the same set of steps in a repetitive fashion, and for sharing protocols with others, but they force you into a rigid way of thinking and can decrease creativity.  
>**Warning: don’t pipeline too early.** Get a method working before you turn it into a pipeline. And even then, does it need to be a pipeline? Have you saved time? Is your pipeline really of use to others? If those steps are only ever going to be run by you, then a simple script will suffice and any attempts at pipelining will simply waste time. Similarly, if those steps will only ever be run once, just run them once, document the fact you did so and move on.

This is mind blowing. Indeed, fancy pipelines may make you look super geeky and professional, but it's really not the center of the work for a computational biologist.

As a scientist, focus on solving scientific questions, and avoid falling into the trap of "coding frenzy".

## 6. An Obama frame of mind

>Yes you can! As a computational biologist, you will need to be creative, from tweaking exist- ing methods to developing entirely new ones. Be adventurous, be prepared to fail, but keep going. It’s amazing what you can achieve by using Google, by asking other people in the field and by teaching yourself how to solve particular problems.

Make good use of Google.

## 7. Be suspicious and trust nobody

>The following experiment is often performed during statistics training. First, a large matrix of random numbers is created and each column is designated as ‘case’ or ‘control’. A statistical test is then applied to each row to test for significant differences between the case data and the control data. You should not be surprised to learn that hundreds of rows come back with P values indicating statistical significance. Biological datasets, such as those generated by genomics experiments are just like this, large and full of noise. **Your data analysis will produce both false positives and false negatives; and there may be systematic bias in the data, introduced either in the experiment or during the analysis.**  
>There is a temptation, even among biologists trained in statistical techniques, to throw caution to the wind when particular software or pipelines produce an interesting result. Instead, treat results with great suspicion, and carry out further tests to determine whether the results can be explained by experimental error or bias. If multiple approaches agree, then your confidence in those answers increases. But for many findings, validation and further work in the laboratory may be necessary. Knowledge of biology is vital in the interpretation of computational results. Setting traps, or tests, as mentioned above, is only part of this. Those tests are meant to ensure that your software or pipeline is working as you expect it to work; it doesn’t necessarily mean that the answers produced are correct.

## 8. The right tool for the job

>Become comfortable working from the UNIX/Linux command line. **The command line is incredibly powerful**, allowing you greater control over what software is doing and allowing you to run and control multiple jobs at once. Most bioinformatics software is designed to be run from the command line. Learn about compute clusters and how to run hundreds of jobs in parallel. You’ll need to be able to code, but the choice of language is not as critical as you may be led to believe by computer scientists. Each language has strengths and weaknesses, and you may have to use more than one to get the job done.  
>Bear in mind that choosing a more popular language will let you benefit from a larger library of existing toolsets, for example the [Bio* projects](http://www.open-bio.org/wiki/Main_Page) from the Open Bioinformatics Foundation. Microsoft Excel is a spreadsheet program, and unless used very carefully, is not suitable for biological data. Store your experimental data, in structured text files or in an SQL database. Employing basic database practice, such as normalization (i.e., ensuring a single place for each piece of data associated with your project), means there are fewer chances to make a mistake later. Make sure everything is backed up, regularly.

These are very basic yet critical advice for computational biology. Let me summarize these in shorter phrases:

* Learn UNIX/Linux command line
* Learn about computer clusters and parallel processing
* Learn a few coding languages, but don't be too obsessed with them
* Learn to manage data properly: storage, processing, backup

## 9. Be a detective

>As a computational biologist, a lot of your time will be spent analyzing and interpreting data. The data are telling you something. They contain a story and it’s your job to find out what that story is. Unless you’re very lucky, it probably won’t be obvious. Finding out will not be easy. You will have to think about **how the experiment was performed**; **how the analysis was performed**; and **what the results are telling you**. You will need to confidently disregard, or control for, what you think are errors and systematic biases in the data.  
>To do the above you may need to talk to other scientists involved in the work, or integrate and analyze additional data. You may need to propose follow-up experiments, designed to test any hypotheses you generate. Remember, the real story may not be in your data at all! If the biological system you’re interested in hinges on phosphorylation of a protein, then you probably won’t see this effect in your RNA-seq data. You are basically a detective. Work the data. Figure it out.

## 10. Someone has already done this. Find them!

>No matter how gnarly a problem or how cutting-edge a method, there is a pretty good chance someone out there has tried to tackle it already. Two excellent resources for discussing problems with software are BioStars (http://www.biostars.org/) and SEQanswers (http://seqanswers.com/). Twitter is another place where you will be able to find advice and links to resources and papers. Hook up with other computational biologists in your department or institute. There is likely to be a local computational biology meeting or interest group in your area, so find it and join up; if there isn’t, why not start your own like Nick did!

Biostar, SEQanswers, and StackOverflow are the bests!

***

上面这些讲得总归是理想情况。做计算生物学（除了做算法开发方向)，只要是研究生物学问题，必然还是要等生物学家做完实验，然后才能拿到数据。

如果课题组氛围好，能和生物学家好好交流，那是最好的情况。在实验开始前大家坐下来先聊一聊：Define The Biological Question，明确研究目标，尽可能将实验设计完善，将可能出现的问题讨论交流清楚，再开展实验。当然这也是极为理想的情况，实际做研究可能没有机会做这么充分的准备。

最常见的情况是生物学家做了个实验，然后把数据丢到我们手里，读入数据一看发现数据质量多少有点问题，实验设计也许也没那么“工整”，这时的分析就有讲究了。当然这些内容和本文无关，在此不再赘述。

不管怎么说，一个训练有素的计算生物学家需要对生物学问题有比较好的把握，对工具也得具备一定程度的理解。不见得需要精通每一个工具，但是基本的计算机操作是基础中的基础，比如UNIX/LINUX操作系统的大体框架应该有个概念（Windows不算！），硬件知识比如CPU显卡内存主板硬盘多少得懂一点，CLI/bash的操作必须熟练掌握，能熟练使用vim绝对是加分项，脚本语言（i.e. Python、R）至少掌握一个，这些都是基本功。建立在这些的基础上，还要寻找有意义的、新颖的生物学课题。好的科学问题才是一切的核心！
