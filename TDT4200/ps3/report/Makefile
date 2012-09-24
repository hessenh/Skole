
all: document.pdf

document.pdf: document.tex
	pdflatex document.tex
	pdflatex document.tex

.PHONY: clean

clean:
	rm document.pdf
	rm document.aux
