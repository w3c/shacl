# delete targets that caused an error
.DELETE_ON_ERROR:

# make as many targets as you can
# .IGNORE:

ebnf-convert = java -jar c:/prog/bin/ebnf-convert.war
rr           = java -jar c:/prog/bin/rr.war

HTML = shaclc-ANTLR.html shaclc-JavaCC.html shaclc-Jison.html shaclc-XText.html 

# MD = shaclc-ANTLR.md shaclc-JavaCC.md shaclc-Jison.md shaclc-XText.md
# Neither embedded PNG nor SVG is rendered by Github markdown

all: $(HTML) # $(MD)

%.html: %.ebnf
	$(rr) $^ > $@

%.md: %.ebnf
	$(rr) -md -png $^ > $@

shaclc-ANTLR.ebnf : shaclc-ANTLR.g4
	$(ebnf-convert) $^ > $@

shaclc-JavaCC.ebnf: shaclc-JavaCC.jj
	$(ebnf-convert) $^ > $@

shaclc-Jison.ebnf : shaclc-Jison.jison
	$(ebnf-convert) $^ > $@

shaclc-XText.ebnf : shaclc-XText.xtext
	$(ebnf-convert) $^ > $@

