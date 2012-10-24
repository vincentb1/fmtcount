STYFILES=fmtcount.sty fcnumparser.sty fcprefix.sty \
	 fc-british.def fc-english.def fc-french.def \
	 fc-german.def fc-portuges.def fc-spanish.def \
	 fc-UKenglish.def fc-USenglish.def fc-ngermanb.def \
	 fc-ngerman.def fc-germanb.def

NLCTDOC=$(HOME)/tex/latex/nlctdoc/nlctdoc.cls

test	: fc-samp.pdf fc-frlargenum.pdf

fc-lang.pdf	: fc-lang.tex $(STYFILES)
		pdflatex fc-lang

fc-samp.pdf	: fc-samp.tex $(STYFILES)
		pdflatex fc-samp
		pdflatex fc-samp

fc-frlargenum.pdf	: fc-frlargenum.tex $(STYFILES)
		pdflatex fc-frlargenum

dist	: README CHANGES fmtcount-manual.tex \
	  fmtcount.perl $(STYFILES) \
	  ../dist/fmtcount.dtx
	dos2unix CHANGES
	dos2unix README
	dos2unix fc-lang.tex
	dos2unix fc-samp.tex
	dos2unix fc-frlargenum.tex
	dos2unix fmtcount.perl
	\cp CHANGES ../dist
	cp2dist -f fmtcount.sty README fmtcount-manual.tex ../dist
	make -C ../dist

../dist/fmtcount.dtx	: $(STYFILES)  \
			  fmtcount-manual.tex 
	makedtx -author "Nicola Talbot and Vincent Belaïche" \
		-src "(.+)\.(sty)=>\1.\2" \
		-src "(.+)\.(def)=>\1.\2" \
		-doc fmtcount-manual.tex fmtcount
	dos2unix fmtcount.dtx
	dos2unix fmtcount.ins
	mv2dist -f fmtcount.sty fmtcount.{dtx,ins} ../dist

../dist/fmtcount.pdf	: ../dist/fmtcount.dtx \
			$(NLCTDOC)
			make -C ../dist fmtcount.pdf

../dist/fmtcount-manual.tex	: fmtcount-manual.tex
	cp2dist -f fmtcount.sty fmtcount-manual.tex ../dist

../dist/fmtcount-manual.html	: ../dist/fmtcount-manual.tex \
				$(NLCTDOC)
	make -C ../dist fmtcount-manual.html

html	: ../dist/fmtcount-manual.html

pdf	: ../dist/fmtcount.pdf

squeaky	:
	make -C ../dist squeaky clean

clean	:
	\rm -f fc-*.{aux,log,pdf}
