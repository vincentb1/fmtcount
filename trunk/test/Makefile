include ../fc-makedefinitions.mak
TESTS:= fc-samp sample-polyglossia

SHORT:=UKenglish\
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
	 spanish

# please set this variable to empty when https://puszcza.gnu.org.ua/bugs/?200 is solved
# that will cause some `regression' as \ordinal of section is going to be tested
TEX4HT_BUG200_PATCH:= !/\\renewcommand{\\thesection}{\\ordinal{section}}/


# italian => does not support 999999
# portuges => does not support 0

FMTCOUNT=$(patsubst ../%,%,$(wildcard ../*.sty) $(wildcard ../*.def))

LOGS:=short


.PHONY: all short big makesubdir



all: short big
	declare -i failure_count; \
	for w in $(patsubst %,%.log,$(LOGS)); do\
		failure_count=$$failure_count+$$(awk '/Total failure count = / {split($$0,a," *= *"); print a[2]}' $$w); \
	done; \
    echo "GRAND TOTAL FAILURE COUNT = $$failure_count"; \
	if [ $$failure_count -ne 0 ]; then \
		echo "ERROR: failure have been found, please correct before commiting changes"; \
		exit -1; \
	fi

short: short.log

$(patsubst %,tests/test-short-%.tex,$(SHORT)):tests/test-short-%.tex: makesubdir
	awk '/^% FCloadlang/ { $$0="\\FCloadlang{$*}\\def\\languagename{$*}\\makeatletter\n\\@set@mulitling@fmtcount\\makeatother"}; $(TEX4HT_BUG200_PATCH) {print}' ../fc-samp.tex > $@


tests/test-short-%.html: tests/test-short-%.tex
	cd tests; htlatex $(patsubst tests/%,%,$<)

# generation date removal, and variable comment removal
tests/test-short-%-nodate.html: tests/test-short-%.html
	awk '!/<meta name="date"/ { gsub(/<!--l\. [0-9]+-->/,""); print}' $< > $@


short.log: $(patsubst %,tests/test-short-%-nodate.html,$(SHORT))
	if [ -f $@ ]; then rm $@; fi
	declare -i diff_count=0; \
	for w in $(SHORT); do \
		echo "Test short-$$w:" >> $@; \
		diff -abs tests/test-short-$$w-nodate.html reference/test-short-$$w.html >> $@; \
		if [ $$? -ne 0 ]; then diff_count=$$diff_count+1; fi; \
	done; \
	echo "Total failure count = $${diff_count}" >> $@


makesubdir: $(patsubst %,../%,$(FMTCOUNT))
	mkdir -p tests
	for w in $(FMTCOUNT); do cp ../$$w tests; done

clean:
	rm -fr tests
	for w in $(LOGS); do rm -fr $$w.log; done

overwrite: overwrite_short


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


