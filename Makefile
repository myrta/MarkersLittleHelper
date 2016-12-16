include vars.mk

%.pdf:%.tex
	$(LATEX) $^

.PHONY: tex
tex: $(REGFILE) $(TEMPLATE_TEX)
	$(SAXON) $(SAXONOPTS) -s:$(REGFILE) -xsl:$(TEMPLATE_TEX) 	
.PHONY: pdf
pdf: $(PDF_FILES)

join.pdf: $(PDF_FILES)
	pdftk $(PDF_FILES) cat output $@

report.zip: $(PDF_FILES)
	zip $@ $(PDF_FILES)
.PHONY: clean
clean:
	rm -f *.aux *.log *.bak $(PDF_FILES) join.pdf
.PHONY: clean_tex
clean_tex:
	rm -f $(TEX_FILES)
.PHONY: clean_all
clean_all: clean_pdf clean_tex
.PHONY: help
help:
	@echo help       - this help
	@echo tex        - create tex files with feedback from xml+template
	@echo pdf        - create pdf files with feedback
	@echo join.pdf   - create one pdf file with all feedbacks 
	@echo clean      - remove pdf files and auxiliary files from latex compilation
	@echo clean_tex  - remove tex files 
	@echo clean_all  - remove tex and pdf files and auxiliary files from latex compilation
