# Shacl Compact Syntax 1.2 Scope Document

As SHACL needs to be updated to support RDF 1.2, there is an opportunity to promote SHACL-C from a CG to WG specification, whilst:
 - Upgrading the SHACL-C spec to support RDF 1.2 features in alignment with upgrades to the other SHACL specs, and
 - Adding support for additional SHACLC-C features

This document outlines the scope of new features to be supported.

## Aligning with RDF 1.2

Syntactic additions will be required for SHACL-C to support the following:

 - [Support for datasets](https://github.com/w3c/shacl/issues/22)
 - [Support for RDF 1.2 (in particular embedded triples)](https://github.com/w3c/shacl/issues/23)
 - [Support for RDF 1.2 text direction](https://github.com/w3c/shacl/issues/24)

Note that this should be done *after* these features have been supported by the core SHACL spec.

## New Features

### Support for additional SHACLC shorthands
 - Support Rules
 - Support (SPARQL) Functions
 - Support shorthand (`<`, `=`, `<=` etc.) for property pair constraints
 - [Support `xone` and more `or` cases](https://github.com/w3c/shacl/issues/12)
 - Opting out of the production of the triple `?baseUri rdf:type owl:Ontology`
 - Support for non-validating characteristics (e.g. generating `sh:order` triples by declaring `@order` at the top of a file/shape, allow grouping by `@group` at the top of a set of properties and allow an `@description` above properties).

The first 2 of these have been supported in [this xtext file](https://gitlab.com/allotrope-open-source/shape-editor/-/blob/master/src/com.osthus.shapes.shaclc.parent/com.osthus.shapes.shaclc/src/com/osthus/shapes/shaclc/SHACLC.xtext) by [allotrope](https://www.allotrope.org/). Some or all of these additions may be ignored in favour of keeping SHACL-C a simple syntax to implement and use.

### [Making SHACLC Lossless](https://github.com/w3c/shacl/issues/36)

There are implementation attempts at lossless SHACL-C by allowing the use of a more turtle-like syntax in places. We should align on a way of doing this and write it up in spec form. Existing attepts are:
 - [Extended Compact Syntax in shaclcjs](https://github.com/jeswr/shaclcjs?tab=readme-ov-file#extended-shacl-compact-syntax)
 - [make shaclc->shacl nearly lossless TopQuadrant/shacl#98](https://github.com/TopQuadrant/shacl/issues/98) (escape into turtle, and some extra links and ideas)

### Extending the test suite

There is also work that can be done to make the test suite more robust such as:
 - [shaclc: missing property shape TopQuadrant/shacl#142](https://github.com/TopQuadrant/shacl/issues/142) (test case)
 - [shaclc->shacl outputs `;` instead of `.` TopQuadrant/shacl#91](https://github.com/TopQuadrant/shacl/issues/91) (test case)
 - [shacl conversion: malformed lists TopQuadrant/shacl#92](https://github.com/TopQuadrant/shacl/issues/92) (test case)


## Implementations
The current SHACL-C implementations are
 - https://jena.apache.org/documentation/shacl/#shacl-compact-syntax
 - https://github.com/jeswr/shaclcjs & https://github.com/jeswr/shaclc-writer
 - https://gitlab.com/allotrope-open-source/shape-editor

## Related Issues
 - [SHACL-compact-syntax #7](https://github.com/w3c/shacl/issues/7)
 - [shaclc grammar: nodeOr vs propertyOr #12](https://github.com/w3c/shacl/issues/12)
 - [Extending SHACLC to enable the expression of any RDF statements #36](https://github.com/w3c/shacl/issues/36)
