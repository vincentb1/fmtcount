include ../fc-makedefinitions.mak
TESTS:= fc-samp sample-polyglossia
SAMPLE_DIR:=.
DASHES:='=================================================================================================='

# Tests with TEX4HT test engine
#------------------------------------------------------------------------------------------------------------
LANG_short:=UKenglish\
	 USenglish\
	 american\
	 british\
	 english\
	 francais\
	 french\
	 frenchb\
	 german\
	 germanb\
	 ngerman\
	 ngermanb\
	 italian\
	 spanish
LANG_shortgo:=english french italian
# note: french cannot be tested with babel + tex4ht engine due to tex4ht problem with babel thin space used in
# french before :;!?, see https://puszcza.gnu.org.ua/bugs/?213.
LANG_shortbab:=english german

# dummy
LANG_fmtord:=l

# Cross referencing tests (for these tests we used global option language loading)
# The lc+ ucf+ uc+ are needed because on MSWindows filenames are case insenstive
# lc = lower case, ucf = upper case first, uc = upper case
LANG_crossref:=french german
CROSSREF:=lc+numberstring ucf+Numberstring uc+NUMBERstring\
	lc+ordinalstring ucf+Ordinalstring uc+ORDINALstring\
	lc+ordinal

CROSSREF_TESTS:=$(patsubst %, test-crossref-%,$(foreach LANG,$(LANG_crossref),$(addprefix $(LANG)+,$(CROSSREF))))

# Tests with pdflatex test engine
#------------------------------------------------------------------------------------------------------------
LATEX_TESTS:=fc-samp fc-frlargenum $(CROSSREF_TESTS)

# Tests with xelatex sample-polyglossia
#------------------------------------------------------------------------------------------------------------
XELATEX_TESTS:=sample-polyglossia

# please set this variable to empty when https://puszcza.gnu.org.ua/bugs/?200 is solved
# that will cause some `regression' as \ordinal of section is going to be tested
TEX4HT_BUG200_PATCH:= !/\\renewcommand{\\thesection}{\\ordinal{section}}/

$(foreach LANG,$(LANG_short),$(eval PRINTROW_$(LANG):=))

# We have to set the following in order to remove occurrence of bug #13
# (https://github.com/nlct/fmtcount/issues/13) and #14 (https://github.com/nlct/fmtcount/issues/14)
PRINTROW_italian:=/^\\printrow/ { match($$0,/\{([0-9]+)\}/,a); n=strtonum(a[1]); if(n>9999) $$0="%- " $$0};\
  $$0=="\\NUMBERstringnum{10}," { $$0 = "%- " $$0} ; \
  $$0=="\\Ordinalstringnum{10}," { sub(/,/,".")} ;   \
  $$0=="\\ORDINALstringnum{10}." { $$0 = "%- " $$0} ; 

$(foreach LANG,$(LANG_short),$(eval CONTENTSNAME_$(LANG):=))

define DEF_CONTENTSNAME
$(eval CONTENTSNAME_$(1):=\n\\def\\contentsname{$(2)}\n)
endef
$(call DEF_CONTENTSNAME,german,Inhaltsverzeichnis)
$(call DEF_CONTENTSNAME,germanb,Inhaltsverzeichnis)
$(call DEF_CONTENTSNAME,ngerman,Inhaltsverzeichnis)
$(call DEF_CONTENTSNAME,ngermanb,Inhaltsverzeichnis)


# italian => does not support 999999
# portuges => does not support 0

LOGS_SHORT:=short shortgo shortbab fmtord
TEX4HT_LOGS:=$(LOGS_SHORT)
LOGS:=pdftests $(TEX4HT_LOGS) 

.PHONY: all
all: $(addsuffix .log,$(LOGS))
	declare -i failure_count; \
	for w in $(addsuffix .log,$(LOGS)); do\
		failure_count=$$failure_count+$$(awk '/Total failure count = / {split($$0,a," *= *"); print a[2]}' $$w); \
	done; \
	echo $(DASHES);\
    echo "== GRAND TOTAL FAILURE COUNT = $$failure_count"; \
	if [ $$failure_count -ne 0 ]; then \
		echo "== ERROR: please correct failed test(s) before commiting changes"; \
		echo $(DASHES);\
		exit -1; \
	fi;\
	echo $(DASHES);



define ERROR_COUNT_AWK
BEGIN { failcount=0} ;\
/^Test [^:]+: failed/ { ++failcount } ;\
END   { print "\nTotal failure count = " failcount}
endef


pdftests.log:  $(patsubst %,pdftests/%.pdf,$(LATEX_TESTS) $(XELATEX_TESTS)) total_pdftests

.PHONY: total_pdftests
total_pdftests: $(patsubst %,pdftests/%.pdf,$(LATEX_TESTS) $(XELATEX_TESTS))
	awk '$(ERROR_COUNT_AWK)' pdftests.log >> pdftests.log
	@echo $(DASHES)
	@echo '== End target pdftests'
	@echo $(DASHES)

.PHONY: echo_pdftest
echo_pdftest:
	rm -f pdftests.log
	@echo $(DASHES)
	@echo '== Begin target pdftests'
	@echo $(DASHES)

define PDF_ACTIONS
	cd pdftests; \
	if latexmk $(1) ../$<; \
	then \
		pdftotext $*.pdf  $*.txt; \
		if diff -abs $*.txt ../reference/$*.txt; then \
			echo "Test $*: ok" >> ../pdftests.log; \
		else echo "Test $*: failed" >> ../pdftests.log; \
		fi; \
	else echo "Test $*: failed" >> ../pdftests.log; \
	fi
endef

$(patsubst %,pdftests/%.pdf,$(LATEX_TESTS)):pdftests/%.pdf:$(SAMPLE_DIR)/%.tex $(patsubst %,pdftests/%,$(STYFILES)) echo_pdftest pdftests/.dir
	$(call PDF_ACTIONS,-pdf -interaction=nonstopmode)

# Cross referencing tests
#------------------------------------------------------------------------------------------------------------
$(patsubst %,$(SAMPLE_DIR)/%.tex,$(CROSSREF_TESTS)):$(SAMPLE_DIR)/%.tex: $(SAMPLE_DIR)/sample-crossref.tex \
		pdftests/.dir
	awk 'BEGIN { split("$*",a,"+"); split(a[1],b,"-"); lang=b[3]; macro=a[3];} ; /^ *\\documentclass/ { sub(/\[[^]]*/,"&," lang)}; /renewcommand/ { sub(/numberstring/,macro);}; {print}' $< > $@


$(patsubst %,pdftests/%.pdf,$(XELATEX_TESTS)):pdftests/%.pdf:$(SAMPLE_DIR)/%.tex $(patsubst %,pdftests/%,$(STYFILES)) \
		echo_pdftest pdftests/.dir
	$(call PDF_ACTIONS,-r ../xelatex_latexmkrc)

# language loaded via FCLoadLang
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-short-%.tex,$(LANG_short)):tests/test-short-%.tex: echo_short tests/.dir
	awk '/^% FCloadlang/ { $$0="\\FCloadlang{$*}\\def\\languagename{$*}\\makeatletter\n\\@set@mulitling@fmtcount\\makeatother$(CONTENTSNAME_$*)"}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $(SAMPLE_DIR)/fc-samp.tex > $@

# language loaded via global option
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-shortgo-%.tex,$(LANG_shortgo)):tests/test-shortgo-%.tex: $(SAMPLE_DIR)/fc-samp.tex \
		echo_shortgo tests/.dir
	awk '/^ *\\documentclass/ { sub(/\[[^]]*/,"&,$*")}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $< > $@

# language loaded via prior usepackage of babel
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-shortbab-%.tex,$(LANG_shortbab)):tests/test-shortbab-%.tex: \
		$(SAMPLE_DIR)/fc-samp.tex echo_shortbab tests/.dir
	awk '/^ *\\usepackage/ { $$0="\\usepackage[$*]{babel}\n" $$0}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $< > $@



# AWK script to normalize the HTML output for short number test
# replace shortgo/shortbab by short in the header source & css reference
# remove xml:lang language specification (when babel used) from <html> attributes
define SHORT_NODATE_AWK
/<meta name="src"/ || /<link rel="stylesheet"/ { sub(/"test-short(go|bab)-/,"\"test-short-")};\
/<html/ {sub(/xml:lang=".." */,"")}; \
!/<meta name="date"/ && !/^ *$$$$/ { gsub(/<!--l\. [0-9]+-->/,""); gsub(/>  +</,"> <");  print}
endef
# "

define SHORTTYPE_RULE
$(1).log: $$(patsubst %,tests/test-$(1)-%-nodate.html,$$(LANG_$(1)))
	if [ -f $$@ ]; then rm $$@; fi
	declare -i diff_count=0; \
	for w in $$(LANG_$(1)); do \
		echo "Test $(1)-$$$$w:" >> $$@; \
		test=$$$$(echo $(1) | sed 's/\(go\|bab\)$$$$//1'); \
		diff -abs tests/test-$(1)-$$$$w-nodate.html reference/test-$$$$test-$$$$w.html >> $$@; \
		if [ $$$$? -ne 0 ]; then diff_count=$$$$diff_count+1; fi; \
	done; \
	echo "Total failure count = $$$${diff_count}" >> $$@
	@echo $(DASHES)
	@echo '== End target $(1)'
	@echo $(DASHES)

tests/test-$(1)-%.html: tests/test-$(1)-%.tex
	cd tests; htlatex $$(patsubst tests/%,%,$$<)

# generation date removal, and variable comment removal
tests/test-$(1)-%-nodate.html: tests/test-$(1)-%.html
	awk '$(SHORT_NODATE_AWK)' $$< > $$@

.PHONY: echo_$(1)
echo_$(1):
	rm -f $(1).log
	@echo $(DASHES)
	@echo '== Begin target $(1)'
	@echo $(DASHES)
endef

tests/test-fmtord-l.tex: sample-fmtord.tex
	cp $< $@

$(foreach SHORTTYPE,$(LOGS_SHORT),$(eval $(call SHORTTYPE_RULE,$(SHORTTYPE))))

.PHONY: makesubdir
makesubdir: $(patsubst %,tests/%,$(STYFILES))

# Docstrip of the poor --- supposedly faster than real docstrip... but I need to check that.
# Does not contain any rule like: /^ *%\^\^A/ { sub(/%\^\^A/,"%"); print }
# because anyway this is for test speed-up, not for distribution.
define DOCSTRIP_AWK
BEGIN                      { printenb = 0; };\
/^%    \\end{macrocode}/   { printenb = 0; };\
printenb == 1              { print };\
/^%    \\begin{macrocode}/ { printenb = 1; }
endef

$(patsubst %,tests/%,$(STYFILES)):tests/%:../% tests/.dir
	awk '$(DOCSTRIP_AWK)' $< > $@

$(patsubst %,pdftests/%,$(STYFILES)):pdftests/%:tests/% pdftests/.dir
	cp -u $< -T $@

tests/.dir:
	mkdir -p tests
	echo "" > $@

pdftests/.dir:
	mkdir -p pdftests
	echo "" > $@

.PHONY: squeaky realclean
squeaky realclean:%: clean

.PHONY: clean
clean: cleanpdf cleantex4ht

.PHONY: cleanpdf
cleanpdf:
	rm -fr pdftests
	rm -f pdftests.log
	echo $(patsubst %,$(SAMPLE_DIR)/%.tex,$(CROSSREF_TESTS)) | xargs rm -f

.PHONY: cleantex4ht
cleantex4ht:
	rm -fr tests
	for w in $(TEX4HT_LOGS); do rm -f $$w.log; done

.PHONY: overwrite
overwrite: overwrite_short


.PHONY: overwrite_short
overwrite_short:
# my bash does not have ;& in case ... esac
	o=no; \
	function overwrite(){ \
		echo "Overwriting reference of test short-$$1"; \
		cp -f tests/test-short-$$1-nodate.html reference/test-short-$$1.html; \
	}; \
	for w in $(SHORT); do \
		if diff -abs tests/test-short-$$w-nodate.html reference/test-short-$$w.html > /dev/null; \
		then echo "Test short-$$w ok"; else \
			if [ $$o == no ]; then \
				echo "Overwrite reference of test short-$$w ?"; \
				select o in yes no all; do \
					case $$o in \
					yes) \
						o=no; \
						overwrite $$w;; \
					all) \
						overwrite $$w;; \
					no) ;; \
					esac; \
					break; \
				done; \
			else \
				overwrite $$w; \
			fi ; \
		fi ; \
	done


