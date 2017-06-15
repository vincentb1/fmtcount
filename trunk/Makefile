include fc-makedefinitions.mak

.PHONY: test
test	:
	$(MAKE) -C test

.PHONY: dist
dist	: README CHANGES fmtcount-manual.tex \
	  fmtcount.perl $(STYFILES) \
	  ../dist/fmtcount.dtx
	command cp CHANGES ../dist
	./cp2dist -f fmtcount.sty README fmtcount-manual.tex ../dist
	$(MAKE) -C ../dist

../dist/fmtcount.dtx	: $(DTX_DEPENDANCIES)
	makedtx -author "Nicola Talbot and Vincent Belaïche" \
		-src "(.+)\.(sty|def)$$=>\1.\2" \
		-doc fmtcount-manual.tex fmtcount
	./mv2dist -f fmtcount.sty fmtcount.{dtx,ins} ../dist

../dist/fmtcount.pdf	: ../dist/fmtcount.dtx 
			$(MAKE) -C ../dist fmtcount.pdf

../dist/fmtcount-manual.tex	: fmtcount-manual.tex
	./cp2dist -f fmtcount.sty fmtcount-manual.tex ../dist

../dist/fmtcount-manual.html	: ../dist/fmtcount-manual.tex 
	$(MAKE) -C ../dist fmtcount-manual.html

.PHONY: doc
doc: html pdf

.PHONY: html
html	: ../dist/fmtcount-manual.html

.PHONY: pdf
pdf	: ../dist/fmtcount.pdf

.PHONY: squeaky realclean
squeaky	realclean:%: clean
	$(MAKE) -C ../dist squeaky clean

.PHONY: clean
clean	:
	command rm -f fc-*.{aux,log,pdf}

# Local Variables:
# coding: utf-8
# End:
