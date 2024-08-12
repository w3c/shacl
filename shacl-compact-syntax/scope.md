# SHACL Compact (SHACL-C) Syntax 1.2 Scope Document

As SHACL needs to be updated to support RDF 1.2, there is an opportunity to promote SHACL-C from a CG to WG specification, whilst:
 - Upgrading the SHACL-C spec to support RDF 1.2 features in alignment with upgrades to the other SHACL specs, and
 - Adding support for additional SHACL-C features

This document outlines the scope of new features to be supported.

## Aligning with RDF 1.2

Syntactic additions will be required for SHACL-C to support the following:

 - [RDF datasets](https://github.com/w3c/shacl/issues/22)
 - [RDF 1.2 triple terms and occurrences](https://github.com/w3c/shacl/issues/23)
 - [RDF 1.2 text direction](https://github.com/w3c/shacl/issues/24)

Note that this should be done *after* these features have been supported by the core SHACL spec.

## New Features

### Extra SHACL-C Syntax Features

The following features will allow SHACL-C to capture more of SHACL, or express it in a nicer way:

- [SPARQL Functions](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#FunctionShape), inspired by SPIN Functions, like SHACL Advanced [functions](https://w3c.github.io/data-shapes/shacl-af/#functions)
- Shorthand (`<`, `=`, `<=`, etc.) for property pair constraints
- [SPARQL Rules](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#RuleShape). 
  - [These rules use](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#RuleBody) `CONSTRUCT`, like SHACL Advanced [SPARQL Rules](https://w3c.github.io/data-shapes/shacl-af/#SPARQLRule) `sh:construct`
    - Note: SHACL Advanced also has [Triple Rules](https://w3c.github.io/data-shapes/shacl-af/#TripleRule) (`subject, property, object`), and we need a syntax for that
  - They have `IF` part being a shape to check, like [sh:condition](https://w3c.github.io/data-shapes/shacl-af/#condition)
  - They have `PRIORITY` part, like [sh:order](https://w3c.github.io/data-shapes/shacl-af/#rules-order)
- Rich [Targets](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#Target) including SPARQL targets.
  The inclusion of SPARQL resulted from implementation experience that expressiveness of SHACL alone was not enough for the Allotrope use case. 
  For example, we need to ensure the unique presence of some nodes in an Allotrope file, and use the SHACL SPARQL extension for it. 
  If we support SPARQL at all, it feels natural to also apply it to `SELECT` targets. 
  Allotrope uses SPARQL sparingly because it is "only" a SHACL extension, so from the view of many of the Allotrope members, not "official" enough.
- [Parameterized SPARQL Targets](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#TargetShape) and [their invocation](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#TargetCall), like SHACL Advanced [SPARQL Target Types](https://w3c.github.io/data-shapes/shacl-af/#SPARQLTargetType)
- [Support `xone` and more `or` cases](https://github.com/w3c/shacl/issues/12)
- Opt out of the production of the triple `?baseUri rdf:type owl:Ontology`
- Non-validating characteristics (e.g., generating `sh:order` triples by declaring `@order` at the top of a file/shape, allow grouping by `@group` at the top of a set of properties, and allowing a `@description` above properties).
- [Graphical Operators](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#OP_XONE) (e.g., `><`, `⊻`, and/or `⩒`) in addition to keywords (e.g., `xone` and/or `xor`).
  This is a way to make SHACL-C even more compact, but many people cannot type them easily. The use of well-known operators can help make code more readable, and we expect that, like all models, they are far more often read then written, but where the boundary of obscurity ends is open to discussion.

### Extra SHACL Features

The following features would extend SHACL, so are subject of discussion (https://github.com/w3c/shacl/issues/74).

The first one comes from RDF4J.
The rest come from [SPARQL Inferencing Notation (SPIN)](https://spinrdf.org/) (the predecessor of SHACL)
and/or the [Allotrope](https://www.allotrope.org/) Shapes Editor (see [SHACLC.xtext](https://gitlab.com/allotrope-open-source/shape-editor/-/blob/master/src/com.osthus.shapes.shaclc.parent/com.osthus.shapes.shaclc/src/com/osthus/shapes/shaclc/SHACLC.xtext)).
Some or all of these additions may be ignored in favour of keeping SHACL-C a simple syntax to implement and use.

- Target shapes, see [rsx:targetShape](https://rdf4j.org/shacl/extensions.html) (implemented in RDF4J ShaclSail)
- [Shape Libraries](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#ShaclDoc) (versioned). Packaging shapes into libraries enables modularized development of shapes. 
  It is used together with [Import](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#ImportsDecl).
  A shape library is very similar to an OWL ontology and technically works in the same way. 
  In fact, we now use OWL ontologies because of inference from `owl:import`, but there was quite some discussion about whether the assembly of shapes is an ontology in the OWL sense. 
  For any large scale application of SHACL, it is necessary to modularize, and it felt like this was a serious gap in the specification.
- [Imports](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#ImportsDecl) (how is this different from `owl:imports`?)
- Rich [Parameter Declarations](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#ParameterDeclaration) and respective assignments at invocation
- [Explicit Syntax](https://rawgit2.com/VladimirAlexiev/shacl/shaclc-grammars/shacl-compact-syntax/grammar/shaclc-XText.html#SparqlConstraint) for SPARQL Constraints, i.e. SPARQL is not embedded in RDF literals (`"""<sparql query>"""`), unlike SHACL SPARQL.
  - Potential benefits:
    - Having a syntax for SPARQL allows a much better integration.
    - We do not have a language within a language.
    - XText (and other grammar based code generators) can be used to directly generate code from it, and it is so much more powerful to have consistency ensured by a single parser.
  - Issue https://github.com/w3c/shacl/issues/75 discusses whether to reintroduce an explicit RDF syntax for SPARQL.

### [Making SHACL-C Lossless](https://github.com/w3c/shacl/issues/36)

There are attempts to implement lossless SHACL-C by allowing the use of a more Turtle-like syntax in places. We should align on a way of doing this and write it up in spec form. Existing attempts include:
 - [Extended Compact Syntax in `shaclcjs`](https://github.com/jeswr/shaclcjs?tab=readme-ov-file#extended-shacl-compact-syntax)
 - [make SHACL-C→SHACL nearly lossless TopQuadrant/shacl#98](https://github.com/TopQuadrant/shacl/issues/98) (escape into Turtle, and some extra links and ideas)

## Extending the Test Suite

There is also work that can be done to make the test suite more robust such as:
 - [SHACL-C: missing property shape TopQuadrant/shacl#142](https://github.com/TopQuadrant/shacl/issues/142) (test case)
 - [SHACL-C→SHACL outputs `;` instead of `.` TopQuadrant/shacl#91](https://github.com/TopQuadrant/shacl/issues/91) (test case)
 - [SHACL conversion: malformed lists TopQuadrant/shacl#92](https://github.com/TopQuadrant/shacl/issues/92) (test case)

## Implementations
Current SHACL-C implementations include those listed below.

**Parsers/writers** (i.e., convertors between SHACL and SHACL-C)
 - TopQuadrant had a SHACL-C implementation that was deprecated in favor of Jena's.
   The the current SHACL-C specification [cites the grammar](https://w3c.github.io/shacl/shacl-compact-syntax/#grammar-section) of this implementation
 - [Jena](https://jena.apache.org/documentation/shacl/#shacl-compact-syntax): implemented in Java
 - [allotrope-open-source/shape-editor](https://gitlab.com/allotrope-open-source/shape-editor): implemented in Java for the Eclipse framework (uses XTEXT).
   Introduces a number of number of new SHACL-C Constructs (see https://github.com/w3c/shacl/issues/52), reflected above.
 - [jeswr/shaclcjs](https://github.com/jeswr/shaclcjs) and [jeswr/shaclc-writer](https://github.com/jeswr/shaclc-writer): implemented in JavaScript
 - [edmondchuc/shaclc](https://github.com/edmondchuc/shaclc): implemented in Python, also has a [playground](https://edmondchuc.github.io/shaclc/)

**Editing helpers**
- [jeswr/shaclc-language-server](https://github.com/jeswr/shaclc-language-server): Language Server, implements IntelliSense-like features for modern IDEs like VS-Code
- [VladimirAlexiev/shaclc-mode](https://github.com/VladimirAlexiev/shaclc-mode): for Emacs, implements syntax checking and highlighting, jumping from reference to definition


## Related Issues
 - [SHACL-compact-syntax #7](https://github.com/w3c/shacl/issues/7)
 - [SHACL-C grammar: nodeOr vs propertyOr #12](https://github.com/w3c/shacl/issues/12)
 - [Extending SHACL-C to enable the expression of any RDF statements #36](https://github.com/w3c/shacl/issues/36)
