SRC=../trunk

all	: fmtcount.pdf

ctan	: fmtcount.zip

install	: fmtcount.sty fmtcount.pdf
	cp fmtcount.pdf $(HOME)/texmf/doc/latex/fmtcount/
	cp fmtcount.sty $(HOME)/texmf/tex/latex/fmtcount/

fmtcount.tds.zip	: fmtcount.pdf \
		  fmtcount.sty \
		  README CHANGES
	mkdir -p doc/latex/fmtcount
	mkdir -p tex/latex/fmtcount
	mkdir -p source/latex/fmtcount
	mkdir -p scripts/fmtcount
	cp *.{sty,def} tex/latex/fmtcount/
	cp fmtcount.{dtx,ins} source/latex/fmtcount
	cp $(SRC)/fmtcount.perl scripts/fmtcount/
	cp fmtcount.pdf README CHANGES doc/latex/fmtcount
	cp $(SRC)/fc-*.tex doc/latex/fmtcount/
	zip -r fmtcount.tds.zip tex source doc scripts

fmtcount.zip	: fmtcount.tds.zip
	mkdir -p fmtcount
	cp fmtcount.{dtx,ins,pdf} fmtcount/
	cp README CHANGES fmtcount/
	cp $(SRC)/fc-*.tex fmtcount/
	cp $(SRC)/fmtcount.perl fmtcount/
	zip -r fmtcount.zip fmtcount/ fmtcount.tds.zip

fmtcount.sty	: fmtcount.dtx fmtcount.ins
		latex fmtcount.ins

fmtcount.pdf	: fmtcount.dtx 
		pdflatex fmtcount.dtx
		makeindex -s gind.ist fmtcount.idx
		makeindex -s gglo.ist -o fmtcount.gls fmtcount.glo
		pdflatex fmtcount.dtx
		pdflatex fmtcount.dtx

fmtcount-manual.html	: fmtcount-manual.tex ../../nlctdoc/nlctdoc.cls
			ht latex fmtcount-manual
			tex '\def\filename{{fmtcount-manual}{idx}{4dx}{ind}} \input idxmake.4ht'
			makeindex -s gind.ist -o fmtcount-manual.ind fmtcount-manual.4dx
			ht latex fmtcount-manual

html	: fmtcount-manual.html 

clean	:
	\rm -f fmtcount.{aux,glo,idx,ilg,ind,log,out,toc,gls}
	\rm -f *.{css,4ct,4tc,aux,dvi,glo,idv,idx,lg,log,tmp,xref,ind,out,toc,4dx,4ix,ilg}
	\rm -f idxmake.{log,dvi}

squeaky	:
	\rm -f fmtcount.{dtx,ins,pdf,perl}
	\rm -f fmtcount-manual.{html,tex}
	\rm -f fmtcount-manual*.png
	\rm -f *.sty *.def
	\rm -f README CHANGES 
	\rm -rf doc/ tex/ source/ fmtcount/ scripts/
	\rm -f fmtcount.zip fmtcount.tds.zip
