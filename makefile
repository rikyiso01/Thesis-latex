
all: compile

compile:
	TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var latexmk -shell-escape -interaction=nonstopmode -pdf -lualatex main.tex
