%{
/*
    Grammar specification for a SHACL compact
    syntax parser.
    Several functions are from <https://github.com/RubenVerborgh/SPARQL.js/>
*/

  // Common namespaces and entities
  const RDF = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
      RDF_TYPE  = RDF + 'type',
      RDF_FIRST = RDF + 'first',
      RDF_REST  = RDF + 'rest',
      RDF_NIL   = RDF + 'nil',
      XSD = 'http://www.w3.org/2001/XMLSchema#',
      XSD_INTEGER  = XSD + 'integer',
      XSD_DECIMAL  = XSD + 'decimal',
      XSD_DOUBLE   = XSD + 'double',
      XSD_BOOLEAN  = XSD + 'boolean',
      SH = 'http://www.w3.org/ns/shacl#',
      OWL = 'http://www.w3.org/2002/07/owl#',
      RDFS = 'http://www.w3.org/2000/01/rdf-schema#';

    // TODO: Make sure all SPARQL supported datatypes are here
    const datatypes = {
      [XSD_INTEGER]: true,
      [XSD_DECIMAL]: true,
      [XSD + 'float']: true,
      [XSD_DOUBLE]: true,
      [XSD + 'string']: true,
      [XSD_BOOLEAN]: true,
      [XSD + 'dateTime']: true,
      [XSD + 'nonPositiveInteger']: true,
      [XSD + 'negativeInteger']: true,
      [XSD + 'long']: true,
      [XSD + 'int']: true,
      [XSD + 'short']: true,
      [XSD + 'byte']: true,
      [XSD + 'nonNegativeInteger']: true,
      [XSD + 'unsignedLong']: true,
      [XSD + 'unsignedShort']: true,
      [XSD + 'unsignedByte']: true,
      [XSD + 'positiveInteger']: true,
      [RDF + 'langString']: true
    }

    function addList(elems, ttlList = false) {   
      let i = 0, l = elems.length;

      // TODO: Double check this behavior and see why it differes from the other l == 0 case
      if (ttlList && l === 0) {
        return Parser.factory.namedNode(RDF_NIL)
      }

      const list = head = blank();

      if (l === 0) {
        // TODO: see if this should be here 
        emit(head, Parser.factory.namedNode(RDF_REST),  Parser.factory.namedNode(RDF_NIL))
      }

      elems.forEach(elem => {
        if (elem === undefined) {
          throw new Error('b')
        }
        emit(head, Parser.factory.namedNode(RDF_FIRST), elem)
        emit(head, Parser.factory.namedNode(RDF_REST),  head = ++i < l ? blank() : Parser.factory.namedNode(RDF_NIL))
      })

      return list;
    }

  // TODO: Port over any updates to this from SPARLQL.js
  // Resolves an IRI against a base path
  function resolveIRI(iri) {
     // Strip off possible angular brackets and resolve the IRI
    return Parser.n3Parser._resolveIRI(iri[0] === '<' ? iri.substring(1, iri.length - 1) : iri)
  }

  function expandPrefix(iri) {
    const namePos = iri.indexOf(':'),
          prefix = iri.substr(0, namePos),
          expansion = Parser.prefixes[prefix];
    
    if (!expansion) throw new Error('Unknown prefix: ' + prefix);
    
    return resolveIRI(expansion + iri.substr(namePos + 1));
  }
  
  // Converts the string to a number
  function toInt(string) {
    return parseInt(string, 10);
  }
  // Creates a literal with the given value and type
  function createTypedLiteral(value, type) {
    if (type && type.termType !== 'NamedNode'){
      type = Parser.factory.namedNode(type);
    }
    return Parser.factory.literal(value, type);
  }
  // Creates a literal with the given value and language
  function createLangLiteral(value, lang) {
    return Parser.factory.literal(value, lang);
  }
  // Creates a new blank node
  function blank(name) {
    if (typeof name === 'string') {  // Only use name if a name is given
      if (name.startsWith('e_')) return Parser.factory.blankNode(name);
      return Parser.factory.blankNode('e_' + name);
    }
    return Parser.factory.blankNode('g_' + blankId++);
  };
  var blankId = 0;
  Parser._resetBlanks = function () { blankId = 0; }
  // Regular expression and replacement strings to escape strings
  var escapeSequence = /\\u([a-fA-F0-9]{4})|\\U([a-fA-F0-9]{8})|\\(.)/g,
      escapeReplacements = { '\\': '\\', "'": "'", '"': '"',
                             't': '\t', 'b': '\b', 'n': '\n', 'r': '\r', 'f': '\f' },
      fromCharCode = String.fromCharCode;
  // Translates escape codes in the string into their textual equivalent
  function unescapeString(string, trimLength) {
    return Parser.n3Parser._lexer._unescape(string.substring(trimLength, string.length - trimLength));
  }

  function emit(s, p, o) {
    if (!s.termType || !p.termType || p.value.includes(',') || !o.termType) {
      throw new Error(`boo ${s.value} ${p.value} ${o.value}`)
    }
    Parser.onQuad(Parser.factory.quad(s, p, o))
  }

  function emitProperty(p, o) {
    emit(Parser.currentPropertyNode, Parser.factory.namedNode(SH + p), o)
  }

  function chainProperty(name, p, o) {
    const b = blank();
    emit(b, Parser.factory.namedNode(SH + p), o);
    return [name, b];
  }

  function ensureExtended(input) {
    if (!Parser.extended) {
      throw new Error('Encountered extended SHACLC syntax; but extended parsing is disabled')
    }
    return input
  }
%}

%lex

PASS                    [ \t\r\n]+ -> skip
COMMENT                 '#' ~[\r\n]* -> skip

IRIREF                  '<' (~[^=<>\"\{\}\|\^`\\\u0000-\u0020] | {UCHAR})* '>'
PNAME_NS                {PN_PREFIX}? ':'
PNAME_LN                {PNAME_NS} {PN_LOCAL}
ATPNAME_NS              '@' {PN_PREFIX}? ':'
ATPNAME_LN              '@' {PNAME_NS} {PN_LOCAL}
LANGTAG                 '@' [a-zA-Z]+ ('-' [a-zA-Z0-9]+)*
INTEGER                 [+-]?[0-9]+
DECIMAL                 [+-]?[0-9]*'.'[0-9]+
DOUBLE                  [+-]?([0-9]+ '.' [0-9]* {EXPONENT} | '.'? [0-9]+ {EXPONENT})
EXPONENT                [eE] [+-]? [0-9]+
// TODO: Refactor these into just STRING_LITERAL ans STRING_LITERAL_LONG with an or
STRING_LITERAL1         "'"(?:(?:[^\u0027\u005C\u000A\u000D])|{ECHAR})*"'"
STRING_LITERAL2         "\""(?:(?:[^\u0022\u005C\u000A\u000D])|{ECHAR})*'"'
STRING_LITERAL_LONG1    "'''"(?:(?:"'"|"''")?(?:[^'\\]|{ECHAR}))*"'''"
STRING_LITERAL_LONG2    "\"\"\""(?:(?:"\""|'""')?(?:[^\"\\]|{ECHAR}))*'"""'
UCHAR                   '\\u' {HEX} {HEX} {HEX} {HEX} | '\\U' {HEX} {HEX} {HEX} {HEX} {HEX} {HEX} {HEX} {HEX}
ECHAR                   '\\' [tbnrf\\\"\']
WS                      [\u0020\u0009\u000D\u000A]
PN_CHARS_BASE           [A-Z] | [a-z] | [\u00C0-\u00D6] | [\u00D8-\u00F6] | [\u00F8-\u02FF] | [\u0370-\u037D] | [\u037F-\u1FFF] | [\u200C-\u200D] | [\u2070-\u218F] | [\u2C00-\u2FEF] | [\u3001-\uD7FF] | [\uF900-\uFDCF] | [\uFDF0-\uFFFD]
PN_CHARS_U              {PN_CHARS_BASE} | '_'
PN_CHARS                {PN_CHARS_U} | '-' | [0-9] | [\u00B7] | [\u0300-\u036F] | [\u203F-\u2040]
PN_PREFIX               {PN_CHARS_BASE} (({PN_CHARS} | '.')* {PN_CHARS})?
PN_LOCAL                ({PN_CHARS_U} | ':' | [0-9] | {PLX}) (({PN_CHARS} | '.' | ':' | {PLX})* ({PN_CHARS} | ':' | {PLX}))?
PLX                     {PERCENT} | {PN_LOCAL_ESC}
PERCENT                 '%' {HEX} {HEX}
HEX                     [0-9] | [A-F] | [a-f]
PN_LOCAL_ESC            '\\' ('_' | '~' | '.' | '-' | '!' | '$' | '&' | '\'' | '(' | ')' | '*' | '+' | ',' | ';' | '=' | '/' | '?' | '#' | '@' | '%')

NODEKIND                'BlankNode' | 'IRI' | 'Literal' | 'BlankNodeOrIRI' | 'BlankNodeOrLiteral' | 'IRIOrLiteral'
TARGET                  'targetNode' | 'targetObjectsOf' | 'targetSubjectsOf' 
PARAM                   'deactivated' | 'severity' | 'message' | 'class' | 'datatype' | 'nodeKind' | 'minExclusive' | 'minInclusive' | 'maxExclusive' | 'maxInclusive' | 'minLength' | 'maxLength' | 'pattern' | 'flags' | 'languageIn' | 'uniqueLang' | 'equals' | 'disjoint' | 'lessThan' | 'lessThanOrEquals' | 'qualifiedValueShape' | 'qualifiedMinCount' | 'qualifiedMaxCount' | 'qualifiedValueShapesDisjoint' | 'closed' | 'ignoredProperties' | 'hasValue' | 'in'

%options flex case-insensitive

%%

\s+|"#"[^\n\r]*         /* ignore */

"BASE"                  return 'KW_BASE'
"IMPORTS"               return 'KW_IMPORTS'
"PREFIX"                return 'KW_PREFIX'

"shapeClass"            return 'KW_SHAPE_CLASS'
"shape"                 return 'KW_SHAPE'

'true'                  return 'KW_TRUE'
'false'                 return 'KW_FALSE'

{NODEKIND}              return 'NODEKIND'
{TARGET}                return 'TARGET'
{PARAM}                 return 'PARAM'

{PASS}                  return 'PASS'
{COMMENT}               return 'COMMENT'

{IRIREF}                return 'IRIREF'
{PNAME_NS}              return 'PNAME_NS'
{PNAME_LN}              return 'PNAME_LN'
{ATPNAME_NS}            return 'ATPNAME_NS'
{ATPNAME_LN}            return 'ATPNAME_LN'
{LANGTAG}               return 'LANGTAG'
{INTEGER}               return 'INTEGER'
{DECIMAL}               return 'DECIMAL'
{DOUBLE}                return 'DOUBLE'
{EXPONENT}              return 'EXPONENT'
{STRING_LITERAL1}       return 'STRING_LITERAL1'
{STRING_LITERAL2}       return 'STRING_LITERAL2'
{STRING_LITERAL_LONG1}  return 'STRING_LITERAL_LONG1'
{STRING_LITERAL_LONG2}  return 'STRING_LITERAL_LONG2'

"->"                    return '->'
".."                    return '..'

"}"                     return '}'
"{"                     return '{'
"("                     return '('
")"                     return ')'
"["                     return '['
"]"                     return ']'

"?"                     return '?'
"*"                     return '*'
"+"                     return '+'

"|"                     return '|'
"^^"                    return '^^'
"."                     return '.'
"!"                     return '!'

"/"                     return '/'
"="                     return '='
"@"                     return '@'
"^"                     return '^'
";"                     return ';'
","                     return ','
"%"                     return '%'
"a"                     return 'a'

<<EOF>>                 return 'EOF'

%ebnf

/lex

%start shaclDoc

%%


shaclDoc            : directiveOrMore nodeShapeOrShapeClassOrMore ttlSection EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | nodeShapeOrShapeClassOrMore ttlSection EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | directiveOrMore ttlSection EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | ttlSection EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | directiveOrMore nodeShapeOrShapeClassOrMore EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | nodeShapeOrShapeClassOrMore EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | directiveOrMore EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    | EOF -> emit(Parser.factory.namedNode(resolveIRI('')), Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(OWL + 'Ontology'))
                    ;

directiveOrMore     : directive 
                    | directive directiveOrMore ;

nodeShapeOrShapeClassOrMore : nodeShapeOrShapeClass
                            | nodeShapeOrShapeClass nodeShapeOrShapeClassOrMore ;

nodeShapeOrShapeClass : nodeShape
                      | shapeClass
                      ;

directive           : baseDecl | importsDecl | prefixDecl ;

baseDecl            : KW_BASE  IRIREF
                    {
                      Parser.base = Parser.factory.namedNode($2.slice(1, -1));
                      Parser.n3Parser._setBase(Parser.base.value);
                    }
                    ;

importsDecl         : KW_IMPORTS IRIREF -> emit(Parser.base, Parser.factory.namedNode(OWL + 'imports'), Parser.factory.namedNode($2.slice(1, -1)))
                    ;

prefixDecl          : KW_PREFIX PNAME_NS IRIREF -> Parser.prefixes[$2.substr(0, $2.length - 1)] = resolveIRI($3)
                    ;

nodeShapeIri        : iri
                    {
                      Parser.nodeShapeStack = false
                      emit(Parser.currentNodeShape = $1, Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(SH + 'NodeShape'))
                    }
                    ;

nodeShape           : KW_SHAPE nodeShapeIri targetClass turtleAnnotation nodeShapeBody
                    | KW_SHAPE nodeShapeIri turtleAnnotation nodeShapeBody
                    | KW_SHAPE nodeShapeIri targetClass nodeShapeBody
                    | KW_SHAPE nodeShapeIri nodeShapeBody
                    ;

shapeClass          : KW_SHAPE_CLASS nodeShapeIri turtleAnnotation nodeShapeBody -> emit(Parser.currentNodeShape, Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(RDFS + 'Class'))
                    | KW_SHAPE_CLASS nodeShapeIri nodeShapeBody -> emit(Parser.currentNodeShape, Parser.factory.namedNode(RDF_TYPE), Parser.factory.namedNode(RDFS + 'Class'))
                    ;

turtleAnnotation    : ';' turtleAnnotation2 -> ensureExtended()
                    ;

turtleAnnotation2   : predicate
                    | predicate turtleAnnotation
                    ;

predicate           : iri objectList -> $2.forEach(e => emit(Parser.currentNodeShape, $1, e))
                    ;

objectList          : object -> [$1]
                    | object objectTailOrMore -> [$1, ...$2]
                    ;

objectTailOrMore    : objectTail
                    | objectTailOrMore objectTail
                    ;

object              : iriOrLiteral
                    | blankNodeSection
                    | list
                    ;

objectOrMore        : object
                    | objectOrMore object
                    ;

list                : '(' ')' -> addList([], true)
                    | '(' objectOrMore ')' -> addList($2, true)
                    ;

objectTail          : ',' object -> $2
                    ;

LB                  : '['
                    {
                      Parser.tempCurrentNodeShape = Parser.currentNodeShape;
                      $$ = Parser.currentNodeShape = blank();
                    }
                    ;

RB                  : ']'
                    {
                      Parser.currentNodeShape = Parser.tempCurrentNodeShape;
                    }
                    ;

blankNodeSection    : LB turtleAnnotation2 RB -> $1
                    ;

LP                  : "%"
                    {
                      Parser.tempCurrentNodeShape = Parser.currentNodeShape;
                      Parser.currentNodeShape = Parser.currentPropertyNode;
                    }
                    ;

RP                  : "%"
                    {
                      Parser.currentNodeShape = Parser.tempCurrentNodeShape
                    }
                    ;

pcSection           : LP turtleAnnotation2 RP
                    ;

iriHead             : iri
                    {
                      Parser.currentNodeShape = $1
                    }
                    ;

ttlStatement        : iriHead turtleAnnotation2 "." 
                    ;

ttlSection          : ttlStatement
                    | ttlSection ttlStatement
                    ;

startNodeShape      : '{'
                    {
                      if (!Parser.nodeShapeStack) {
                        Parser.nodeShapeStack = [];
                      } else {
                        Parser.nodeShapeStack.push(Parser.currentNodeShape);
                        emit(
                          Parser.currentPropertyNode,
                          Parser.factory.namedNode(SH + 'node'),
                          Parser.currentNodeShape = blank(),
                        )
                      }
          
                      $$ = Parser.currentNodeShape;
                    }
                    ;

endNodeShape        : '}'
                    {
                      if (Parser.nodeShapeStack.length > 0) {
                        Parser.currentNodeShape = Parser.nodeShapeStack.pop();
                      }
                    }
                    ;

constraintOrMore    : constraint
                    | constraintOrMore constraint
                    ;

nodeShapeBody       : startNodeShape endNodeShape -> $1
                    | startNodeShape constraintOrMore endNodeShape -> $1
                    ;

iriOrMore           : iri
                    | iriOrMore iri
                    ;

targetClass         : '->' iriOrMore -> $2.forEach(node => { emit(Parser.currentNodeShape, Parser.factory.namedNode(SH + 'targetClass'), node) })
                    ;

nodeOrEmitOrMore    : nodeOrEmit
                    | nodeOrEmitOrMore nodeOrEmit
                    ;

nodeOrEmitOrMoreOrPropertyShape : nodeOrEmitOrMore
                                | propertyShape
                                ;

constraint          : nodeOrEmitOrMoreOrPropertyShape pcSection '.'
                    | nodeOrEmitOrMoreOrPropertyShape '.'
                    ;

orNotComponent      : '|' nodeNot -> $2
                    ;

nodeOrEmit          : nodeOr -> emit(Parser.currentNodeShape, Parser.factory.namedNode(SH + $1[0]), $1[1])
                    ;

orNotComponentOrMore : orNotComponent
                     | orNotComponentOrMore orNotComponent
                     ;

nodeOr              : nodeNot
                    {
                    }
                    | nodeNot orNotComponentOrMore
                    {
                      const o = addList([$1, ...$2].map(elem => {
                        const x = blank();
                        emit(x, Parser.factory.namedNode(SH + elem[0]), elem[1]);
                        return x;
                      }))

                      $$ = ['or',  o]
                    }
                    ;
nodeNot             : nodeValue
                    | negation nodeValue -> chainProperty('not', ...$2)
                    ;

targetOrParam : TARGET | PARAM ;

nodeValue           : targetOrParam '=' iriOrLiteralOrArray -> [$1, $3]
                    ;

propertyShape       : path 
                    | propertyShape propertyCount
                    | propertyShape propertyOr
                    ;

propertyOrComponent : '|' propertyNot -> $2
                    ;

propertyOr          : propertyNot
                    | propertyOr propertyOrComponent
                    ;

propertyNot         : propertyAtom
                    | negation propertyAtom -> chainProperty('not', ...$2)
                    ;

propertyAtom        : iri -> [datatypes[$1.value] ? 'datatype' : 'class', $1]
                    | NODEKIND -> ['nodeKind', Parser.factory.namedNode(SH + $1)]
                    | shapeRef -> ['node', Parser.factory.namedNode($1)]
                    | PARAM '=' iriOrLiteralOrArray -> [$1, $3]
                    | nodeShapeBody -> undefined //['node', $1]
                    ;

propertyCount       : '[' propertyMinCount '..' propertyMaxCount ']' 
                    ;

propertyMinCount    : INTEGER -> $1 > 0 && emitProperty('minCount', createTypedLiteral($1, XSD_INTEGER))
                    ;

propertyMaxCount    : INTEGER -> emitProperty('maxCount', createTypedLiteral($1, XSD_INTEGER))
                    | '*'
                    ;

shapeRef            : ATPNAME_LN
                    | ATPNAME_NS
                    | '@' IRIREF
                    ;

negation            : '!' ;

path                : pathAlternative
                    {
                      emit(
                        Parser.currentNodeShape,
                        Parser.factory.namedNode(SH + 'property'),
                        Parser.currentPropertyNode = blank(),
                      )
                      
                      emitProperty('path', $1)
                    }
                    ;

additionalAlternative : '|' pathSequence -> $2
                      ;

pathAlternative     : pathSequence
                    | pathAlternative additionalAlternative
                    ;

additionalSequence : '/' pathEltOrInverse -> $2
                    ;

pathSequence        : pathEltOrInverse
                    | pathSequence additionalSequence

                    ;
pathElt             : pathPrimary
                    | pathPrimary pathMod
                    ;
pathEltOrInverse    : pathElt
                    | pathInverse pathElt
                    ;
pathInverse         : '^' ;
pathMod             : '?' -> 'zeroOrOnePath'
                    | '*' -> 'zeroOrMorePath'
                    | '+' -> 'oneOrMorePath'
                    ;

pathPrimary         : iri
                    | '(' pathAlternative ')' -> $2
                    ;

iriOrLiteralOrMore  : iriOrLiteral
                    | iriOrLiteralOrMore iriOrLiteral
                    ;

iriOrLiteralOrArray : iriOrLiteral
                    | '[' ']'
                    | '[' iriOrLiteralOrMore ']'
                    ;

iriOrLiteral        : iri | literal ;

iri : IRIREF
    | PNAME_LN
    | PNAME_NS
    | 'a'
    ;

literal
    : string -> createTypedLiteral($1)
    | string LANGTAG  -> createLangLiteral($1, lowercase($2.substr(1)))
    | string '^^' iri -> createTypedLiteral($1, $3)
    | INTEGER -> createTypedLiteral($1, XSD_INTEGER)
    | DECIMAL -> createTypedLiteral($1, XSD_DECIMAL)
    | DOUBLE -> createTypedLiteral($1.toLowerCase(), XSD_DOUBLE)
    | KW_TRUE -> createTypedLiteral($1.toLowerCase(), XSD_BOOLEAN)
    | KW_FALSE -> createTypedLiteral($1.toLowerCase(), XSD_BOOLEAN)
    ;

string
    : STRING_LITERAL1
    | STRING_LITERAL2
    | STRING_LITERAL_LONG1
    | STRING_LITERAL_LONG2
    ;
