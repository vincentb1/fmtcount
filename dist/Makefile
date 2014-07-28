TEXMF_INSTALL_DIR?=$(HOME)/texmf
SRC=../trunk
include $(SRC)/fc-makedefinitions.mak


all	: fmtcount.pdf

ctan	: fmtcount.zip

install	:  fmtcount.pdf $(STYFILES) $(TEXMF_INSTALL_DIR)/doc/latex/fmtcount $(TEXMF_INSTALL_DIR)/tex/latex/fmtcount
	command cp fmtcount.pdf $(TEXMF_INSTALL_DIR)/doc/latex/fmtcount/
	command cp $(STYFILES) $(TEXMF_INSTALL_DIR)/tex/latex/fmtcount/

$(TEXMF_INSTALL_DIR)/doc/latex/fmtcount:
	mkdir -p $@

$(TEXMF_INSTALL_DIR)/tex/latex/fmtcount:
	mkdir -p $@

fmtcount.tds.zip	: fmtcount.pdf \
		  fmtcount.sty \
		  README CHANGES
	mkdir -p doc/latex/fmtcount
	mkdir -p tex/latex/fmtcount
	mkdir -p source/latex/fmtcount
	mkdir -p scripts/fmtcount
	command cp *.{sty,def} tex/latex/fmtcount/
	command cp fmtcount.{dtx,ins} source/latex/fmtcount
	command cp $(SRC)/fmtcount.perl scripts/fmtcount/
	command cp fmtcount.pdf README CHANGES doc/latex/fmtcount
	command cp $(SRC)/fc-*.tex doc/latex/fmtcount/
	zip -r fmtcount.tds.zip tex source doc scripts

fmtcount.zip	: fmtcount.tds.zip
	mkdir -p fmtcount
	command cp fmtcount.{dtx,ins,pdf} fmtcount/
	command cp README CHANGES fmtcount/
	command cp $(SRC)/fc-*.tex fmtcount/
	command cp $(SRC)/fmtcount.perl fmtcount/
	zip -r fmtcount.zip fmtcount/ fmtcount.tds.zip

$(STYFILES):%: fmtcount.dtx fmtcount.ins
		latex fmtcount.ins

fmtcount.pdf	: fmtcount.dtx 
		pdflatex fmtcount.dtx
		makeindex -s gind.ist fmtcount.idx
		makeindex -s gglo.ist -o fmtcount.gls fmtcount.glo
		pdflatex fmtcount.dtx
		pdflatex fmtcount.dtx

fmtcount.dtx: $(patsubst %,../trunk/%,$(DTX_DEPENDANCIES))
	$(MAKE) -C ../trunk dist

fmtcount-manual.html	: fmtcount-manual.tex ../../nlctdoc/nlctdoc.cls
			ht latex fmtcount-manual
			tex '\def\filename{{fmtcount-manual}{idx}{4dx}{ind}} \input idxmake.4ht'
			makeindex -s gind.ist -o fmtcount-manual.ind fmtcount-manual.4dx
			ht latex fmtcount-manual

html	: fmtcount-manual.html 

clean	:
	command rm -f fmtcount.{aux,glo,idx,ilg,ind,log,out,toc,gls}
	command rm -f *.{css,4ct,4tc,aux,dvi,glo,idv,idx,lg,log,tmp,xref,ind,out,toc,4dx,4ix,ilg}
	command rm -f idxmake.{log,dvi}

squeaky	:
	command rm -f fmtcount.{dtx,ins,pdf,perl}
	command rm -f fmtcount-manual.{html,tex}
	command rm -f fmtcount-manual*.png
	command rm -f *.sty *.def
	command rm -f README CHANGES 
	command rm -rf doc/ tex/ source/ fmtcount/ scripts/
	command rm -f fmtcount.zip fmtcount.tds.zip
