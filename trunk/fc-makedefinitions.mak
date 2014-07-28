SHELL:=/bin/bash
STYFILES=fmtcount.sty fcnumparser.sty fcprefix.sty \
	 fc-british.def fc-english.def fc-french.def \
	 fc-german.def fc-portuges.def fc-spanish.def \
	 fc-UKenglish.def fc-USenglish.def fc-ngermanb.def \
	 fc-ngerman.def fc-germanb.def
DTX_DEPENDANCIES=$(STYFILES) fmtcount-manual.tex
