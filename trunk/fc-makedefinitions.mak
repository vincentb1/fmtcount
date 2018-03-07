SHELL:=/bin/bash
STYFILES=fmtcount.sty fcnumparser.sty fcprefix.sty \
	 fc-british.def fc-brazilian.def fc-english.def fc-american.def \
	 fc-french.def fc-frenchb.def fc-francais.def \
	 fc-german.def fc-portuges.def fc-portuguese.def fc-spanish.def \
	 fc-UKenglish.def fc-USenglish.def fc-ngermanb.def \
	 fc-ngerman.def fc-germanb.def fc-italian.def \
	 fc-arabic.def
DTX_DEPENDANCIES=$(STYFILES) fmtcount-manual.tex
# Driver must be first in list
DOCSTRIP:=fmtcount.ins fmtcount.dtx
EMPTY:=#
SPACE:=$(EMPTY) #	

# Local Variables:
# mode: makefile
# End:
