include ../fc-makedefinitions.mak
TESTS:= fc-samp sample-polyglossia
DUMMY_LANG_TESTS:=fmtord aaalph
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

LANG_shortenc:=	 english\
	 french\
	 german\
	 brazilian\
	 spanish

LANG_shortgo:=english french italian

# note: french cannot be tested with babel + tex4ht engine due to tex4ht problem with babel thin space used in
# french before :;!?, see https://puszcza.gnu.org.ua/bugs/?213.
LANG_shortbab:=english german portuges

# Cross referencing tests (for these tests we used global option language loading)
# The lc+ ucf+ uc+ are needed because on MSWindows filenames are case insenstive
# lc = lower case, ucf = upper case first, uc = upper case
LANG_crossref:=french german
CROSSREF:=lc+numberstring ucf+Numberstring uc+NUMBERstring\
	lc+ordinalstring ucf+Ordinalstring uc+ORDINALstring\
	lc+ordinal

# Cross referencing tests non language dependent
CROSSREF2:=na+binary na+octal na+decimal \
	uc+Hexadecimal lc+hexadecimal \
	uc+AAAlph lc+aaalph

CROSSREF_TESTS:=$(patsubst %, test-crossref-%,$(foreach LANG,$(LANG_crossref),$(addprefix $(LANG)+,$(CROSSREF)))) \
	$(addprefix test-crossref-,$(CROSSREF2))

# Tests with pdflatex test engine
#------------------------------------------------------------------------------------------------------------
LATEX_TESTS:=fc-samp fc-frlargenum $(CROSSREF_TESTS)

# Tests with xelatex sample-polyglossia
#------------------------------------------------------------------------------------------------------------
XELATEX_TESTS:=sample-polyglossia sample-arabic

# Tests with lualatex sample-polyglossia-lua
#------------------------------------------------------------------------------------------------------------
LUALATEX_TESTS:=sample-polyglossia-lua

PDF_TESTS:=$(LATEX_TESTS) $(XELATEX_TESTS) $(LUALATEX_TESTS)


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

LOGS_SHORT:=short shortenc shortgo shortbab $(DUMMY_LANG_TESTS)
TEX4HT_LOGS:=$(LOGS_SHORT)
LOGS:=pdftests $(TEX4HT_LOGS)

DIST:=../../dist

# set to yes awk or no
USE_DOCSTRIP?=yes

ifeq ($(USE_DOCSTRIP),yes)
DOCSTRIP:=$(addprefix $(DIST)/,$(DOCSTRIP))
else
DOCSTRIP:=
endif

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


# Target for each log.
define _1
.PHONY: $(1)
$(1): $(1).log

endef
$(eval $(foreach LOG,$(LOGS),$(call _1,$(LOG))))


define ERROR_COUNT_AWK
BEGIN { failcount=0} ;\
/^Test [^:]+: failed/ { ++failcount } ;\
END   { print "\nTotal failure count = " failcount}
endef


pdftests.log:  $(patsubst %,pdftests/%.pdf,$(PDF_TESTS)) \
	$(patsubst %,pdftests/%,$(STYFILES)) \
	total_pdftests

.PHONY: total_pdftests
total_pdftests: $(patsubst %,pdftests/%.pdf,$(PDF_TESTS))
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
	if latexmk --interaction=nonstopmode $(1) ../$<; \
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
	awk 'BEGIN { n=split("$*",a,"+"); if( n == 3){ split(a[1],b,"-"); lang=b[3]; macro=a[3];} else { macro = a[2]; }} ; /^ *\\documentclass/ && n == 3 { sub(/\[[^]]*/,"&," lang)}; /renewcommand/ { sub(/numberstring/,macro);}; {print}' $< > $@


$(patsubst %,pdftests/%.pdf,$(XELATEX_TESTS)):pdftests/%.pdf:$(SAMPLE_DIR)/%.tex $(patsubst %,pdftests/%,$(STYFILES)) \
		echo_pdftest pdftests/.dir
	$(call PDF_ACTIONS,-r ../xelatex_latexmkrc)

$(patsubst %,pdftests/%.pdf,$(LUALATEX_TESTS)):pdftests/%.pdf:$(SAMPLE_DIR)/%.tex $(patsubst %,pdftests/%,$(STYFILES)) \
		echo_pdftest pdftests/.dir
	$(call PDF_ACTIONS,-r ../lualatex_latexmkrc)


# language loaded via FCLoadLang
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-short-%.tex,$(LANG_short)):tests/test-short-%.tex: echo_short
	awk '/^% FCloadlang/ { $$0="\\FCloadlang{$*}\\def\\languagename{$*}\\makeatletter\n\\@set@mulitling@fmtcount\\makeatother$(CONTENTSNAME_$*)"}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $(SAMPLE_DIR)/fc-samp.tex > $@

# language loaded via FCLoadLang, with FCLoadLang encapsulated in a group
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-shortenc-%.tex,$(LANG_shortenc)):tests/test-shortenc-%.tex: echo_shortenc
	awk '/^% FCloadlang/ { $$0="{\\FCloadlang{$*}}\\def\\languagename{$*}\\makeatletter\n\\@set@mulitling@fmtcount\\makeatother$(CONTENTSNAME_$*)"}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $(SAMPLE_DIR)/fc-samp.tex > $@

# language loaded via global option
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-shortgo-%.tex,$(LANG_shortgo)):tests/test-shortgo-%.tex: $(SAMPLE_DIR)/fc-samp.tex \
		echo_shortgo
	awk '/^ *\\documentclass/ { sub(/\[[^]]*/,"&,$*")}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $< > $@

# language loaded via prior usepackage of babel
#------------------------------------------------------------------------------------------------------------
$(patsubst %,tests/test-shortbab-%.tex,$(LANG_shortbab)):tests/test-shortbab-%.tex: \
		$(SAMPLE_DIR)/fc-samp.tex echo_shortbab
	awk '/^ *\\usepackage/ { $$0="\\usepackage[$*]{babel}\n" $$0}; $(PRINTROW_$*) $(TEX4HT_BUG200_PATCH) {print}' $< > $@



# AWK script to normalize the HTML output for short number test
# replace shortgo/shortbab by short in the header source & css reference
# remove xml:lang language specification (when babel used) from <html> attributes
define SHORT_NODATE_AWK
/<meta name="src"/ || /<link rel="stylesheet"/ { sub(/"test-short(go|bab|enc)-/,"\"test-short-")};\
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
		test=$$$$(echo $(1) | sed 's/\(go\|bab\|enc\)$$$$//1'); \
		diff -abs tests/test-$(1)-$$$$w-nodate.html reference/test-$$$$test-$$$$w.html >> $$@; \
		if [ $$$$? -ne 0 ]; then diff_count=$$$$diff_count+1; fi; \
	done; \
	echo "Total failure count = $$$${diff_count}" >> $$@
	@echo $(DASHES)
	@echo '== End target $(1)'
	@echo $(DASHES)

tests/test-$(1)-%.html: tests/test-$(1)-%.tex
	cd tests; htlatex $$(patsubst tests/%,%,$$<) '' '' '' '\nonstopmode' 

# generation date removal, and variable comment removal
tests/test-$(1)-%-nodate.html: tests/test-$(1)-%.html
	awk '$(SHORT_NODATE_AWK)' $$< > $$@

.PHONY: echo_$(1)
echo_$(1): makesubdir_t4ht
	rm -f $(1).log
	@echo $(DASHES)
	@echo '== Begin target $(1)'
	@echo $(DASHES)
endef

# Dummy lang tests, test which don't need to hack language before running the test
define _1
LANG_$(1):=l

tests/test-$(1)-l.tex: sample-$(1).tex tests/.dir echo_$(1)
	cp $$< $$@

endef
$(eval $(foreach TEST,$(DUMMY_LANG_TESTS),$(call _1,$(TEST))))

$(foreach SHORTTYPE,$(LOGS_SHORT),$(eval $(call SHORTTYPE_RULE,$(SHORTTYPE))))

.PHONY: makesubdir_t4ht
makesubdir_t4ht: $(patsubst %,tests/%,$(STYFILES)) tests/.dir

# Docstrip of the poor --- supposedly faster than real docstrip... but I need to check that.
# Does not contain any rule like: /^ *%\^\^A/ { sub(/%\^\^A/,"%"); print }
# because anyway this is for test speed-up, not for distribution.
define DOCSTRIP_AWK
BEGIN                      { printenb = 0; };\
/^%    \\end{macrocode}/   { printenb = 0; };\
printenb == 1              { print };\
/^%    \\begin{macrocode}/ { printenb = 1; }
endef

ifeq ($(USE_DOCSTRIP),yes)
$(addprefix tests/,$(STYFILES)):tests/%:$(DIST)/% tests/.dir
	cd tests; \
	if [ -f $(notdir $@) ]; then rm $(notdir $@); fi; \
	ln -s ../$< $(notdir $@)

$(addprefix $(DIST)/,$(STYFILES)):%:$(DOCSTRIP)
	$(MAKE) -C $(dir $@) $(notdir $@)


$(DOCSTRIP):%:$(addprefix ../,$(DTX_DEPENDANCIES))
	$(MAKE) -C $(dir $@) $(notdir $@)
else ifeq ($(USE_DOCSTRIP),awk)
$(addprefix tests/,$(STYFILES)):tests/%:../% tests/.dir
	awk '$(DOCSTRIP_AWK)' $< > $@
else ifeq ($(USE_DOCSTRIP),no)
$(addprefix tests/,$(STYFILES)):tests/%:../% tests/.dir
	cd tests; ln -s ../$< $(notdir $@)
else
$(error $(error USE_DOCSTRIP flag shall be set to one of yes no awk)
endif

# trigger regeneration of the STYFILES with the USE_DOCSTRIP variable
# content is changed
.PHONY: docstrip_check
docstrip_check: tests/docstrip_check
	if [ ! "`cat $<`"==$(USE_DOCSTRIP) ]; then echo -n $(USE_DOCSTRIP) > $<; fi

tests/docstrip_check: tests/.dir
	echo -n $(USE_DOCSTRIP) > $@


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
ifeq ($(USE_DOCSTRIP),yes)
	$(MAKE) -C $(dir $(firstword $(DOCSTRIP))) $@
endif

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
overwrite: overwrite_short overwrite_pdftests


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


.PHONY: overwrite_pdftests
overwrite_pdftests:
	o=no; \
	function overwrite(){ \
		echo "Overwriting reference of test $$1"; \
		cp -f pdftests/$$1.pdf reference/$$1.pdf; \
		cp -f pdftests/$$1.txt reference/$$1.txt; \
	}; \
	for w in $(PDF_TESTS); do \
		if diff -abs pdftests/$$w.txt reference/$$w.txt > /dev/null; \
		then echo "Test $$w ok"; else \
			if [ $$o == no ]; then \
				echo "Overwrite reference of test $$w ?"; \
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

.PHONY: help
help:
	@echo "List of targets"
	@echo "  all"
	@echo "  pdftests"
	@echo "  short"
	@echo "  shortenc"
	@echo "  shortgo"
	@echo "  shortbab"
	@echo "  fmtord"
	@echo "  aaalph"
	@echo "  squeaky realclean"
	@echo "  clean"
