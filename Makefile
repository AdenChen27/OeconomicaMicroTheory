MAIN := main
AUX_DIR := aux
CHAPTER_DIR := chapters
CHAPTER_SOURCES := $(shell grep -lE '^[[:space:]]*\\chapter(\*)?([[:space:]]*\[[^]]*\])?[[:space:]]*\{' $(CHAPTER_DIR)/*.tex | sort)
CHAPTERS := $(patsubst $(CHAPTER_DIR)/%.tex,%,$(CHAPTER_SOURCES))
CHAPTER_PDFS := $(addprefix $(CHAPTER_DIR)/,$(addsuffix .pdf,$(CHAPTERS)))
CHAPTER_DEPENDENCIES := $(filter-out $(CHAPTER_DIR)/chapter.tex,$(wildcard $(CHAPTER_DIR)/*.tex))

.PHONY: all book chapters clean clean-book clean-chapters

all: book chapters

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

chapters: $(CHAPTER_PDFS)

$(CHAPTER_PDFS): $(CHAPTER_DIR)/%.pdf: $(CHAPTER_DIR)/%.tex $(CHAPTER_DIR)/chapter.tex $(CHAPTER_DIR)/compile-chapter $(CHAPTER_DEPENDENCIES) ref.bib
	./$(CHAPTER_DIR)/compile-chapter "$*"

clean: clean-book clean-chapters

clean-book:
	latexmk -C \
		-outdir="$(AUX_DIR)" \
		-jobname="$(MAIN)" \
		"$(MAIN).tex"
	rm -f "$(MAIN).pdf"

clean-chapters:
	@for chapter in $(CHAPTERS); do \
		latexmk -C \
			-outdir="$(CHAPTER_DIR)/aux/$$chapter" \
			-jobname="$$chapter" \
			"$(CHAPTER_DIR)/chapter.tex"; \
		rm -f "$(CHAPTER_DIR)/$$chapter.pdf"; \
	done
