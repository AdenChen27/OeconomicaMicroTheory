MAIN := main
AUX_DIR := aux

.PHONY: all book clean

all: book

book:
	mkdir -p "$(AUX_DIR)"
	latexmk \
		-xelatex \
		-interaction=nonstopmode \
		-halt-on-error \
		-outdir="$(AUX_DIR)" \
		-jobname="$(MAIN)" \
		"$(MAIN).tex"
	cp "$(AUX_DIR)/$(MAIN).pdf" "$(MAIN).pdf"

clean:
	latexmk -C \
		-outdir="$(AUX_DIR)" \
		-jobname="$(MAIN)" \
		"$(MAIN).tex"
	rm -f "$(MAIN).pdf"
