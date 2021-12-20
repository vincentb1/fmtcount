# fmtcount package FAQ

This is the old FAQ for the fmtcount package, copied from
[https://www.dickimaw-books.com/faq.php](https://www.dickimaw-books.com/faq.php?action=view&category=fmtcount).
See also the [package documentation](http://mirrors.ctan.org/macros/latex/contrib/fmtcount/fmtcount.pdf) and the [GitHub repository](https://github.com/vincentb1/fmtcoun). Note that `fmtcount` is now under a new maintainer, so information in this FAQ only refers to queries and issues with old versions.

[General Queries](#general_queries)
- Is there multilingual support?
- Why is there only limited multilingual support?
- How do I get septante instead of soixante-dix?
- How do I get the feminine form instead of the masculine?
- How can I set up a different set of default package options?
- How do I get the ordinal suffix to be level instead of a superscript?
- How do I use the value of a label in `\numberstring`, `\ordinalstring`, etc?
[Package Errors](#package_errors)
- The `fmtcount` package conflicts with the `memoir` class
- Unknown language 'english' error
- Command `\@ordinalMenglish` already defined
[Unexpected Output](#unexpected_output)
- `\padzeroes` is a digit short with `\decimal`
- `\MakeUppercase` doesn't work with `\ordinalstring`, etc
- Spaces are ignored after `\numberstring`, `\ordinalstring`, etc
[LaTeX2HTML Support](#latex2html_support)
- Why does LaTeX2HTML ignore `fmtcount.cfg`?


<a name="general_queries" />
## General Queries

### Is there multilingual support?

Currently there is multilingual support for English, French, Spanish, Portuguese and German.

2013-12-09 09:29:13


### Why is there only limited multilingual support?

Because there is a limit to the number of languages I can speak! If you like, you can volunteer to write and maintain a language file for fmtcount.

2013-12-09 09:32:03


### How do I get septante instead of soixante-dix?

If the currently selected language is French, you can select the Swiss or Belgium variants using:

\fmtcountsetoptions{french=swiss}

or

\fmtcountsetoptions{french=belgian}

2021-12-18 21:20:39


### How do I get the feminine form instead of the masculine?

Use the optional argument f to \ordinal etc.

2013-12-09 09:33:27


### How can I set up a different set of default package options?

Create a file called fmtcount.cfg, and put the appropriate commands in it. Then save it to somewhere on the TeX path. However, if you share your document code with other people, make sure you also supply your custom fmtcount.cfg file if it's important that they replicate your date and time format. (Note that if you are also using the datetime package, datetime.cfg will override fmtcount.cfg.)

2013-12-09 09:35:57


### How do I get the ordinal suffix to be level instead of a superscript?

Use:

\fmtcountsetoptions{fmtord=level}

2013-12-09 09:37:42


### How do I use the value of a label in \numberstring, \ordinalstring etc?

Try using Heiko Oberdiek's refcount package which provides commands that will set a counter to the number given by a label. You can then pass that counter to \numberstring etc. For example:

\documentclass{article}

\usepackage{fmtcount}
\usepackage{refcount}

\begin{document}
\newcounter{myctr}\setcounterpageref{myctr}{pg:last}
First page. This document has \numberstring{myctr} pages.

\newpage
Second page.\label{pg:last}
\end{document}

2013-12-09 09:38:48


<a name="package_errors" />
## Package Errors

### The fmtcount package conflicts with the memoir class

You need to use at least version 1.04 of the fmtcount package and use \FCordinal to access fmtcount's version of \ordinal and use \ordinal to use memoir's version of that command.

2013-12-09 09:40:25


### Unknown language 'english' error

Make sure you are using at least version 1.07 of the fmtcount package.

2013-12-09 09:41:10


### Command \@ordinalMenglish already defined

This bug appeared in version 1.06. You need to upgrade to a later version.

2013-12-09 09:42:18


<a name="unexpected_output" />
## Unexpected Output

### \padzeroes is a digit short with \decimal

This was fixed in version 1.05.

2013-12-09 09:43:28


### \MakeUppercase doesn't work with \ordinalstring etc

This is caused by the way \MakeUppercase expands its argument. (see, e.g. \count reference breaks \MakeUppercase or Case-changing oddities). As from version 1.09, you can use one of the commands \ORDINALstring, \NUMBERstring etc, which will convert the text to upper case.

2013-12-09 09:45:31


### Spaces are ignored after \numberstring, \ordinalstring etc

This was fixed in version 1.2.

2013-12-09 09:46:13


<a name="latex2html_support" />
## LaTeX2HTML Support

### Why does LaTeX2HTML ignore fmtcount.cfg?

Because I haven't found a way to implement it.

2013-12-09 09:47:22
