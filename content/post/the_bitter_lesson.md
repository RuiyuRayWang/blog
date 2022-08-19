---
title: "The Bitter Lesson"
date: 2022-05-27T09:21:08+08:00
draft: false
mathjax: false
tags:        ["Machine Learning"]
categories:  ["Stat & Math" ]
---

Richard Sutton, the reknowned computer scientist, author of the AI bible: 'Reinforcement Learning', wrote this essay three years after Alphago beat Lee Sedol.

{{< figure src="../../figs/the_bitter_lesson.png">}}

<http://www.incompleteideas.net/IncIdeas/BitterLesson.html>

The article was originally written for AI researches, but the idea can be extrapolated to other fields.

>Most AI research has been conducted as if the computation available to the agent were constant (in which case leveraging human knowledge would be one of the only ways to improve performance) but, over a slightly longer time than a typical research project, massively more computation inevitably becomes available. 

>Seeking an improvement that makes a difference in the shorter term, researchers seek to leverage their human knowledge of the domain, but the only thing that matters in the long run is the leveraging of computation. **These two need not run counter to each other, but in practice they tend to. Time spent on one is time not spent on the other.** There are psychological commitments to investment in one approach or the other. And the human-knowledge approach tends to complicate methods in ways that make them less suited to taking advantage of general methods leveraging computation.

The take home message: one should resist the temptation of using too much human knowledge.  
By saying this I do not mean that one should forfeit human knowledge completely. Note that I've used the word "temptation". The habit of using human knowledge can be quite addictive, and one should be cautious not to be obsessed to it.

Being in a biological institute for 7 years, I've seen so many people trapping themselves into the deep hole in the way they practice biological science. There's no doubt that these people are intellectually gifted. 

But the world we live in is far more complicated than what brain can comprehend.

...to be continued...

>In speech recognition, there was an early competition, sponsored by DARPA, in the 1970s. ... As in the games, researchers always tried to make systems that worked the way the researchers thought their own minds worked---they tried to put that knowledge in their systems---but it proved ultimately counterproductive, and a colossal waste of researcher's time, when, through Moore's law, massive computation became available and a means was found to put it to good use.

>This is a big lesson. As a field, we still have not thoroughly learned it, as we are continuing to make the same kind of mistakes. To see this, and to effectively resist it, we have to understand the appeal of these mistakes. **We have to learn the bitter lesson that building in how we think we think does not work in the long run.** The bitter lesson is based on the historical observations that 1) AI researchers have often tried to build knowledge into their agents, 2) this always helps in the short term, and is personally satisfying to the researcher, but 3) in the long run it plateaus and even inhibits further progress, and 4) breakthrough progress eventually arrives by an opposing approach based on scaling computation by search and learning. The eventual success is tinged with bitterness, and often incompletely digested, because it is success over a favored, human-centric approach.

>One thing that should be learned from the bitter lesson is the great power of general purpose methods, of methods that continue to scale with increased computation even as the available computation becomes very great. The two methods that seem to scale arbitrarily in this way are *search* and *learning*.

>The second general point to be learned from the bitter lesson is that **the actual contents of minds are tremendously, irredeemably complex; we should stop trying to find simple ways to think about the contents of minds**, such as simple ways to think about space, objects, multiple agents, or symmetries. All these are part of the arbitrary, intrinsically-complex, outside world. They are not what should be built in, as their complexity is endless; instead we should build in only the meta-methods that can find and capture this arbitrary complexity. Essential to these methods is that they can find good approximations, but the search for them should be by our methods, not by us. **We want AI agents that can discover like we can, not which contain what we have discovered.** Building in our discoveries only makes it harder to see how the discovering process can be done.
