# Unifying SHACL-C Grammars
(Task: https://github.com/w3c/shacl/issues/37#issuecomment-1997655429 )

As a first task of the SHACL Compact Syntax Task Force, we look at proposed SHACL-C grammars:

- [ANTLR](shaclc-ANTLR.g4) (was part of TopQuadrant SHACL, also in the [grammar-section](https://w3c.github.io/shacl/shacl-compact-syntax/#grammar-section) of the candidate spec) by @HolgerKnublauch
- [JavaCC](https://github.com/apache/jena/blob/main/jena-shacl/shaclc/shaclc.jj) (part of Jena) by @afs
- [XText](https://gitlab.com/allotrope-open-source/shape-editor/-/blob/master/src/com.osthus.shapes.shaclc.parent/com.osthus.shapes.shaclc/src/com/osthus/shapes/shaclc/SHACLC.xtext) (part of Allotrope-open-source) by @tw-osthus
- [Jison](https://github.com/jeswr/shaclcjs/blob/main/lib/shaclc.jison) (part of shacl.js) by @jeswr 

We use two tools to understand them and try to unify them:
- https://github.com/GuntherRademacher/ebnf-convert to convert them to W3C-style EBNF, which is also needed for official publication.
- https://github.com/GuntherRademacher/rr to produce "rail-road" diagrams, which make it easier to understand the grammars.

Problems:
- DONE: Unicode escapes in XText: https://github.com/GuntherRademacher/ebnf-convert/issues/8 .
  This was fixed 22-Mar-2024: build from source and use `build/distributions/ebnf-convert-0.68-SNAPSHOT-java11.zip/ebnf-convert.war`
- DONE: fixed problems in Jison: https://github.com/w3c/shacl/issues/48 .

`rr` can make railroad diagrams in HTML or Markdown.
- The Markdown uses embedded images (eg `data:image/png;base64`), which are not rendered by Github (neither PNG nor SVG)
- We could ask `rr` to put the images outside, but I think that's too much trouble
- So instead, we use HTML where the images are embedded as SVG and render properly

# Candidate SHACL-C Grammars

- [shacl-ANTLR.g4](shacl-ANTLR.g4) -> [shacl-ANTLR.ebnf](shacl-ANTLR.ebnf) -> [shaclc-ANTLR.html](https://rawgit2.com/shacl/master/shacl-compact-syntax/grammar/shaclc-ANTLR.html) (or [in branch](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-ANTLR.html))
- [shacl-JavaCC.jj](shacl-JavaCC.jj) -> [shacl-JavaCC.ebnf](shacl-JavaCC.ebnf) -> [shaclc-JavaCC.html](https://rawgit2.com/shacl/master/shacl-compact-syntax/grammar/shaclc-JavaCC.html) (or [in branch](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-JavaCC.html))
- [shacl-XText.xtext](shacl-XText.xtext) -> [shacl-XText.ebnf](shacl-XText.ebnf) -> [shaclc-XText.html](https://rawgit2.com/shacl/master/shacl-compact-syntax/grammar/shaclc-XText.html) (or [in branch](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html))
- [shacl-Jison.jison](shacl-Jison.jison) -> [shacl-Jison.ebnf](shacl-Jison.ebnf) -> [shaclc-Jison.html](https://rawgit2.com/shacl/master/shacl-compact-syntax/grammar/shaclc-Jison.html) (or [in branch](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-Jison.html))

