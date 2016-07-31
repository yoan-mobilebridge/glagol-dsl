module Syntax::Concrete::Grammar

extend Syntax::Concrete::Grammar::Keywords;
extend Syntax::Concrete::Grammar::Layout;
extend Syntax::Concrete::Grammar::Lexical;

start syntax Module
   = \module: ^"module" Namespace namespace ";" Import* imports Artifact? artifact
   ;

syntax Namespace 
    = Name name
    | Name name "::" Namespace sub
    ;

syntax Import
    = \import: "import" Namespace namespace "::" ArtifactName artifact ImportAlias? alias ";"
    ;
    
syntax ImportAlias
    = "as" ArtifactName alias
    ;

syntax Artifact
    = Annotation* annotations "entity" ArtifactName name "{" Declaration* declarations "}"
    | Annotation* annotations "repository" "for" ArtifactName name "{" Declaration* declarations "}"
    | "value" ArtifactName name "{" Declaration* declarations "}"
    | ("util" | "service") ArtifactName name "{" Declaration* declarations "}"
    ;

syntax Annotation
    = "@" Identifier id AnnotationArgs?
    ;

syntax AnnotationArgs
    = "(" {AnnotationArg ","}+ args ")"
    ;

syntax AnnotationArg
    = StringQuoted stringVal 
    | Boolean boolean
    | DecimalIntegerLiteral number
    | DeciFloatNumeral number
    | "[" {AnnotationArg ","}+ listVal "]"
    | "{" {AnnotationPair ","}+ mapVal "}"
    ;

syntax AnnotationPair
    = AnnotationKey key ":" AnnotationValue value
    ;

syntax AnnotationValue
    = AnnotationArg val
    | "primary"
    | Type type 
    ;

syntax Declaration
    = Annotation* annotations Type type MemberName name AccessProperties? accessProperties ";"
    | "relation" RelationDir l ":" RelationDir r ArtifactName entity "as" MemberName alias AccessProperties? accessProperties ";"
    | ArtifactName "(" {Parameter ","}* parameters ")" "{" Statement* body "}" (When when ";")?
    | ArtifactName "(" {Parameter ","}* parameters ")" When? when ";"
    | Modifier? modifier Type returnType MemberName name "(" {Parameter ","}* parameters ")" "{" Statement* body "}" (When when ";")?
    | Modifier? modifier Type returnType MemberName name "(" {Parameter ","}* parameters ")" "=" Expression expr When? when ";"
    | "inject" ArtifactName artifact "as" MemberName alias ";"
    ;

syntax Modifier
    = "private"
    | "public"
    ;

syntax When
    = "when" Expression expr
    ;

syntax Parameter
    = Type paramType MemberName name ParameterDefaultValue? defaultValue
    ;

syntax ParameterDefaultValue
    = "=" DefaultValue defaultValue
    ;

syntax DefaultValue
    = stringLiteral : StringQuoted string
    | intLiteral : DecimalIntegerLiteral number
    | floatLiteral : DeciFloatNumeral number
    | booleanLiteral : Boolean boolean
    | \list : "[" {DefaultValue ","}* items "]" list
    ;

syntax AccessProperties
    = "with" "{" {AccessProperty ","}* props "}"
    ;

syntax Type
    = integer: "int"
    | \float: "float"
    | string: "string"
    | \bool: "bool"
    | \bool: "boolean"
    | voidValue: "void"
    | typedList: Type type "[]"
    | typedMap: "{" Type key "," Type v "}"
    > artifactType: ArtifactName name
    ;

syntax StringQuoted 
    = "\"" StringCharacter* string "\""
    ;

syntax Expression
    = bracket \bracket: "(" Expression expression ")"
    | \list: "[" {Expression ","}* items "]"
    | \map: "{" {MapPair ","}* items "}"
    | negative: "-" Expression argument
    | stringLiteral: StringQuoted string
    | intLiteral: DecimalIntegerLiteral number
    | floatLiteral: DeciFloatNumeral number
    | booleanLiteral: Boolean boolean
    | variable: MemberName varName
    | newInstance: "new" ArtifactName
    | newInstance: "new" ArtifactName "(" {Expression ","}* args ")"
    | invoke: (Expression prev ".")? MemberName method "(" {Expression ","}* args ")"
    | fieldAccess: Expression prev "." MemberName field
    | this: "this"
    > left ( product: Expression lhs "*" () !>> "*" Expression rhs
           | remainder: Expression lhs "%" Expression rhs
           | division: Expression lhs "/" Expression rhs
    )
    > left ( addition: Expression lhs "+" Expression rhs
           | subtraction: Expression lhs "-" Expression rhs
    )
//    > left modulo: Expression lhs "mod" Expression rhs
    > non-assoc ( greaterThanOrEq: Expression lhs "\>=" Expression rhs
                | lessThanOrEq: Expression lhs "\<=" Expression rhs
                | lessThan: Expression lhs "\<" !>> "-" Expression rhs
                | greaterThan: Expression lhs "\>" Expression rhs
    )
    > non-assoc ( equals: Expression lhs "==" Expression rhs
                | nonEquals: Expression lhs "!=" Expression rhs
    )
    > left and: Expression lhs "&&" Expression rhs
    > left or: Expression lhs "||" Expression rhs
    > right ifThenElse: Expression condition "?" Expression thenExp ":" Expression elseExp
    ;

syntax MapPair
    = Expression key ":" Expression val
    ;

syntax Statement
    = expression: Expression expression ";"
    | block: "{" Statement* statements "}"
    | ifThen: "if" "(" Expression condition ")" Statement then () !>> "else"
    | ifThenElse: "if" "(" Expression condition ")" Statement then "else" Statement else
    | assign: Assignable assignable AssignOperator operator Statement value !emptyStmt!block!ifThen!ifThenElse!return!break
    | foreach: "for" "(" Expression list "as" MemberName var (","  {Expression ","}+ conditions)? ")" Statement body
    > non-assoc  (
            \return: "return" Expression? expr ";"
        |   \break: "break" Integer? level ";"
        |   \continue: "continue" Integer? level ";"
        |   declare: Type type MemberName varName "=" Statement defaultValue !emptyStmt!block!ifThen!ifThenElse!return!declare
        |   declare: Type type MemberName varName ";"
    )
    > emptyStmt: ";"
    ;   

syntax Assignable
    = variable: MemberName varName
    | fieldAccess: Expression prev "." MemberName field
    | arrayAccess: Assignable variable "[" Expression key "]"
    ;

syntax AssignOperator
    = divisionAssign: "/=" 
    | productAssign: "*=" 
    | subtractionAssign: "-=" 
    | defaultAssign: "=" 
    | additionAssign: "+=" 
    ;
