
all: document.pdf

document.pdf: document.tex reduction.pdf speedup.tex
	pdflatex document.tex
	pdflatex document.tex

reduction.pdf:  reduction.gv
	dot -Tpdf -o reduction.pdf reduction.gv

.PHONY: clean

clean:
	rm document.pdf
	rm document.aux
