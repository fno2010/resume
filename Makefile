SRC = $(wildcard *.md)
PYTHON=python2

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
LATEX_TEMPLATE=./pandoc-templates/default.latex

all:    clean $(PDFS) $(HTML)

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	$(PYTHON) resume.py html $(GRAVATAR_OPTION) < $< | pandoc -t html -c resume.css -s -M pagetitle="Resume" -o $@

%.pdf:  %.md $(LATEX_TEMPLATE)
	$(PYTHON) resume.py tex < $< | pandoc $(PANDOCARGS) --variable subparagraph --template=$(LATEX_TEMPLATE) -H header.tex -o $@

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	$(RM) *.html *.pdf

$(LATEX_TEMPLATE):
	git submodule update --init
