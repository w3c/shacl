# Unifying SHACLC Grammars
(Task: https://github.com/w3c/shacl/issues/37#issuecomment-1997655429 )

As a first task of the SHACL Compact Syntax sub-WG, we look at proposed SHACLC grammars:

- [ANTLR](shaclc-ANTLR.g4) (was part of TopQuadrant SHACL, also in the [grammar-section](https://w3c.github.io/shacl/shacl-compact-syntax/#grammar-section) of the candidate spec) by @HolgerKnublauch
- [JavaCC](https://github.com/apache/jena/blob/main/jena-shacl/shaclc/shaclc.jj) (part of Jena) by @afs
- [XTEXT](https://gitlab.com/allotrope-open-source/shape-editor/-/blob/master/src/com.osthus.shapes.shaclc.parent/com.osthus.shapes.shaclc/src/com/osthus/shapes/shaclc/SHACLC.xtext) (part of Allotrope-open-source) by @tw-osthus
- [Jison](https://github.com/jeswr/shaclcjs/blob/main/lib/shaclc.jison) (part of shacl.js) by @jeswr 

We use two tools to understand them and try to unify them:
- https://github.com/GuntherRademacher/ebnf-convert to convert them to W3C-style EBNF, which is also needed for official publication.
- https://github.com/GuntherRademacher/rr to produce "rail-road" diagrams, which make it easier to understand the grammars.

Problems:
- Unicode escapes in XText: https://github.com/GuntherRademacher/ebnf-convert/issues/8
- Two problems in Jison: https://github.com/w3c/shacl/issues/48

Initial results:
- shacl-ANTLR.g4 -> shacl-ANTLR.ebnf
