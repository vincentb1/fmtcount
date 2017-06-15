SHELL:=/bin/bash
STYFILES=fmtcount.sty fcnumparser.sty fcprefix.sty \
	 fc-british.def fc-english.def fc-american.def \
	 fc-french.def fc-frenchb.def fc-francais.def \
	 fc-german.def fc-portuges.def fc-spanish.def \
	 fc-UKenglish.def fc-USenglish.def fc-ngermanb.def \
	 fc-ngerman.def fc-germanb.def fc-italian.def
DTX_DEPENDANCIES=$(STYFILES) fmtcount-manual.tex
EMPTY:=#
SPACE:=$(EMPTY) #	
