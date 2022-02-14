---
title: "Hugo：启用Mathjax实现数学公式的编辑与显示"
date: 2022-02-12T21:17:37+08:00
draft: true
mathjax: true
tags:        ["Hugo", "Blog", "Mathjax"]
categories:  ["Hugo" ]
---

The HUGO official document has a nice blog about [MathJax Support](https://bwaycer.github.io/hugo_tutorial.hugo/tutorials/mathjax/).
Additionally, a blog written by Geoff Ruddock has a more concise solution: [Render LaTeX math expressions in Hugo with MathJax 3](https://geoffruddock.com/math-typesetting-in-hugo/).

# TL;DR

1. Create a file in your theme directory `layouts/partials/mathjax_support.html` as the following:

```
<script>
  MathJax = {
    tex: {
      inlineMath: [['$', '$'], ['\\(', '\\)']],
      displayMath: [['$$','$$'], ['\\[', '\\]']],
      processEscapes: true,
      processEnvironments: true
    },
    options: {
      skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre']
    }
  };

  window.addEventListener('load', (event) => {
      document.querySelectorAll("mjx-container").forEach(function(x){
        x.parentElement.classList += 'has-jax'})
    });

</script>
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script type="text/javascript" id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
```

2. Next, open the file `layouts/partials/header.html` and add the following line just before the closing </head> tag:

```
{{ if .Params.mathjax }}{{ partial "mathjax_support.html" . }}{{ end }}
```

3. Then, add the following lines to your CSS file. You may need to tinker with the contents here depending on your theme, these are just the settings which worked for me.  

```
code.has-jax {font: inherit;
              font-size: 100%;
              background: inherit;
              border: inherit;
              color: #515151;}
```

To modify css, refer to [Add Custom CSS Or Javascript To Your Hugo Site](https://www.banjocode.com/post/hugo/custom-css/)。

4. Finally, add `mathjax: true` to the YAML frontmatter of any pages containing math markup. Alternatively, you could omit the outer `{{ if .Params.mathjax }} … {{ end }}` conditional above to load the library automatically on all pages. However given that this library is quite heavy (it’s consistently the asset that Google PageSpeed Insights complains the most about) and that only <20% of my blog posts contain math at all, this is worth the extra effort for me.

***

# TODO

走完上面的流程后还是发现MathJax中`\color`和`\textcolor`不能修改字体颜色。  
custom.css似乎也没有正确配置。