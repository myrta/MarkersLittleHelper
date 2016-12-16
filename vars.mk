TEX_FILES=$(wildcard *.tex)
PDF_FILES=$(patsubst %.tex, %.pdf, $(TEX_FILES))
LATEX = pdflatex
SAXON = saxonb-xslt
SAXONOPTS = -ext:on 
TEMPLATE_TEX = mark2texfiles.xslt
REGFILE = Class_Register.xml
