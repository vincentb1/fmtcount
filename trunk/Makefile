include fc-makedefinitions.mak
DIST:=../dist

.PHONY: test
test	:
	$(MAKE) -C test

.PHONY: dist
dist	: README CHANGES fmtcount-manual.tex \
	  fmtcount.perl $(STYFILES) \
	  $(DIST)/fmtcount.dtx
	command cp CHANGES $(DIST)
	./cp2dist $(addprefix -f$(SPACE),$(STYFILES)) README fmtcount-manual.tex $(DIST)
	$(MAKE) -C $(DIST)

$(addprefix $(DIST)/,$(DOCSTRIP))	: $(DTX_DEPENDANCIES)
	makedtx -author "Nicola Talbot and Vincent Belaïche" \
		-src "(.+)\.(sty|def)$$=>\1.\2" \
		-doc fmtcount-manual.tex fmtcount
	./cp2dist -m $(addprefix -f$(SPACE),$(STYFILES)) fmtcount.{dtx,ins} $(DIST)

$(DIST)/fmtcount.pdf	: $(addprefix $(DIST)/,$(DOCSTRIP))
			$(MAKE) -C $(DIST) fmtcount.pdf

$(DIST)/fmtcount-manual.tex	: fmtcount-manual.tex
	./cp2dist $(addprefix -f$(SPACE),$(STYFILES)) fmtcount-manual.tex $(DIST)

$(DIST)/fmtcount-manual.html	: $(DIST)/fmtcount-manual.tex 
	$(MAKE) -C $(DIST) fmtcount-manual.html

.PHONY: doc
doc: html pdf

.PHONY: html
html	: $(DIST)/fmtcount-manual.html

.PHONY: pdf
pdf	: $(DIST)/fmtcount.pdf

.PHONY: squeaky realclean
squeaky	realclean:%: clean
	$(MAKE) -C $(DIST) squeaky clean
	$(MAKE) -C test realclean

.PHONY: clean
clean	:
	command rm -f fc-*.{aux,log,pdf}

# Local Variables:
# coding: utf-8
# End:
