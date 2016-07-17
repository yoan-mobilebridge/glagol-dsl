@doc="This is automatically generated file. Do not edit"
module Parser::Converter
import Syntax::Abstract::AST;
import Syntax::Concrete::Grammar;
import Parser::ParseCode;
import ParseTree;
import String;
import Exceptions::ParserExceptions;



public Declaration convertArtifact((Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`) 
    = entity("<name>", {convertDeclaration(d, "<name>") | d <- declarations});

public Declaration convertArtifact((Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, entity("<name>", {convertDeclaration(d, "<name>") | d <- declarations}));


public AssignOperator convertAssignOperator((AssignOperator) `/=`) = divisionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `*=`) = productAssign();
public AssignOperator convertAssignOperator((AssignOperator) `-=`) = subtractionAssign();
public AssignOperator convertAssignOperator((AssignOperator) `=`) = defaultAssign();
public AssignOperator convertAssignOperator((AssignOperator) `+=`) = additionAssign();


public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);

public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> } <When when>;`, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) { <Statement* body> } <When when>;`, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
    
public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr>;`, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))]);

public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr>;`, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))]);

public Declaration convertDeclaration(
    (Declaration) `<Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr><When when>;`, _) 
    = method(\public(), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))], convertWhen(when));

public Declaration convertDeclaration(
    (Declaration) `<Modifier modifier><Type returnType><MemberName name> (<{Parameter ","}* parameters>) = <Expression expr><When when>;`, _) 
    = method(convertModifier(modifier), convertType(returnType), "<name>", [convertParameter(p) | p <- parameters], [\return(expression(convertExpression(expr)))], convertWhen(when));
    
private Modifier convertModifier((Modifier) `public`) = \public();
private Modifier convertModifier((Modifier) `private`) = \private();
    


public Expression convertExpression((Expression) `(<Expression expr>)`) = \bracket(convertExpression(expr));

public Expression convertExpression((Expression) `<Expression lhs> * <Expression rhs>`) 
    = product(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> / <Expression rhs>`) 
    = division(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> + <Expression rhs>`) 
    = addition(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> - <Expression rhs>`) 
    = subtraction(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \>= <Expression rhs>`) 
    = greaterThanOrEq(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \<= <Expression rhs>`) 
    = lessThanOrEq(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \< <Expression rhs>`) 
    = lessThan(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> \> <Expression rhs>`) 
    = greaterThan(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> == <Expression rhs>`) 
    = equals(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> != <Expression rhs>`) 
    = nonEquals(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> && <Expression rhs>`) 
    = and(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression lhs> || <Expression rhs>`) 
    = or(convertExpression(lhs), convertExpression(rhs));
    
public Expression convertExpression((Expression) `<Expression condition>?<Expression thenExp>:<Expression elseExp>`) 
    = ifThenElse(convertExpression(condition), convertExpression(thenExp), convertExpression(elseExp));

public Expression convertExpression((Expression) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((Expression) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((Expression) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((Expression) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((Expression) `[<{Expression ","}* items>]`)
    = array([convertExpression(i) | i <- items]);
    
public Expression convertExpression((Expression) `<MemberName varName>`)
    = variable("<varName>");
    
public Expression convertExpression((Expression) `-<Expression expr>`) 
    = negative(convertExpression(expr));

public Expression convertExpression((DefaultValue) `<StringQuoted string>`)
    = strLiteral(convertStringQuoted(string));
    
public Expression convertExpression((DefaultValue) `<DecimalIntegerLiteral number>`)
    = intLiteral(toInt("<number>"));
    
public Expression convertExpression((DefaultValue) `<DeciFloatNumeral number>`)
    = floatLiteral(toReal("<number>"));
    
public Expression convertExpression((DefaultValue) `<Boolean boolean>`)
    = boolLiteral(convertBoolean(boolean));
    
public Expression convertExpression((DefaultValue) `[<{DefaultValue ","}* items>]`)
    = array([convertExpression(i) | i <- items]);
    


public Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name>;`, _) 
    = \value(convertType(valueType), "<name>");
    
public Declaration convertDeclaration((Declaration) `value <Type valueType><MemberName name><AccessProperties accessProperties>;`, _) 
    = \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name>;`, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>"));
    
public Declaration convertDeclaration((Declaration) `<Annotation* annotations>value <Type valueType><MemberName name><AccessProperties accessProperties>;`, _) 
    = annotated({convertAnnotation(annotation) | annotation <- annotations}, \value(convertType(valueType), "<name>", convertAccessProperties(accessProperties)));


public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    } 
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body]);
}
    
public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>) { <Statement* body> }<When when>;`, 
    str artifactName)
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], [convertStmt(stmt) | stmt <- body], convertWhen(when));
}

public Declaration convertDeclaration(
    (Declaration) `<ArtifactName name> (<{Parameter ","}* parameters>);`, 
    str artifactName) 
{
    if (artifactName != "<name>") {
        throw IllegalConstructorName("\'<name>\' is invalid constructor name");
    }
    
    return constructor([convertParameter(p) | p <- parameters], []);
}


public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src> <UseAlias as>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), convertUseAlias(as));
    
public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseAlias as>;`)
    = use("<target>", "<artifactType>", internalUse(), convertUseAlias(as));
    
public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType> <UseSource src>;`)
    = use("<target>", "<artifactType>", convertUseSource(src), "<target>");

public Declaration convertUse((Use) `use <ArtifactName target> <ArtifactType artifactType>;`)
    = use("<target>", "<artifactType>", internalUse(), "<target>");
    
private UseSource convertUseSource((UseSource) `from <Name src>`) = externalUse("<src>");

private str convertUseAlias((UseAlias) `as <ArtifactName as>`) = "<as>";


public bool convertBoolean((Boolean) `true`) = true;
public bool convertBoolean((Boolean) `false`) = false;


public Statement convertStmt((Statement) `<Expression expr>;`) = expression(convertExpression(expr));
public Statement convertStmt((Statement) `;`) = emptyStmt();
public Statement convertStmt((Statement) `{<Statement* stmts>}`) = block([convertStmt(stmt) | stmt <- stmts]);

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then>`) 
    = ifThen(convertExpression(condition), convertStmt(then));

public Statement convertStmt((Statement) `if ( <Expression condition> ) <Statement then> else <Statement e>`) 
    = ifThenElse(convertExpression(condition), convertStmt(then), convertStmt(e));

public Statement convertStmt((Statement) `<Assignable assignable><AssignOperator operator><Statement val>`) 
    = assign(convertAssignable(assignable), convertAssignOperator(operator), convertStmt(val));

public Statement convertStmt((Statement) `return <Statement stmt>`) = \return(convertStmt(stmt));

public Statement convertStmt((Statement) `break ;`) = \break();
public Statement convertStmt((Statement) `break<Integer level>;`) = \break(toInt("<level>"));

public Statement convertStmt((Statement) `<Type t> <MemberName varName>;`) = declare(convertType(t), variable("<varName>"));
public Statement convertStmt((Statement) `<Type t> <MemberName varName>=<Statement defValue>`) 
    = declare(convertType(t), variable("<varName>"), convertStmt(defValue));

public Statement convertStmt((Statement) `for (<Expression l>as<MemberName var>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>"), convertStmt(body));
    
public Statement convertStmt((Statement) `for (<Expression l>as<MemberName var>, <{Expression ","}+ conds>)<Statement body>`)
    = foreach(convertExpression(l), variable("<var>"), convertStmt(body), [convertExpression(cond) | cond <- conds]);


public Annotation convertAnnotation((Annotation) `@<Identifier id>`) = annotation("<id>", []);

public Annotation convertAnnotation((Annotation) `@<Identifier id><AnnotationArgs args>`)
    = annotation("<id>", convertAnnotationArgs(args));

private list[Annotation] convertAnnotationArgs((AnnotationArgs) `(<{AnnotationArg ","}+ args>)`) 
    = [convertAnnotationArg(arg) | arg <- args];

private Annotation convertAnnotationArg((AnnotationArg) `<StringQuoted stringVal>`) 
    = annotationVal(convertStringQuoted(stringVal));
    
private Annotation convertAnnotationArg((AnnotationArg) `<Boolean boolean>`) 
    = annotationVal(convertBoolean(boolean));
    
private Annotation convertAnnotationArg((AnnotationArg) `<DecimalIntegerLiteral number>`) 
    = annotationVal(toInt("<number>"));

private Annotation convertAnnotationArg((AnnotationArg) `<DeciFloatNumeral number>`) 
    = annotationVal(toReal("<number>"));

private Annotation convertAnnotationArg((AnnotationArg) `[<{AnnotationArg ","}+ listVal>]`)
    = annotationVal([convertAnnotationArg(arg) | arg <- listVal]);

private Annotation convertAnnotationArg((AnnotationArg) `{<{AnnotationPair ","}+ mapVal>}`)
    = annotationMap(( key:\value | p <- mapVal, <str key, Annotation \value> := convertAnnotationPair(p) ));

private Annotation convertAnnotationValue((AnnotationValue) `<AnnotationArg val>`) = convertAnnotationArg(val);
private Annotation convertAnnotationValue((AnnotationValue) `primary`) = annotationValPrimary();
private Annotation convertAnnotationValue((AnnotationValue) `<Type t>`) = annotationVal(convertType(t));

private tuple[str key, Annotation \value] convertAnnotationPair((AnnotationPair) `<AnnotationKey key> : <AnnotationValue v>`) 
    = <"<key>", convertAnnotationValue(v)>;


public RelationDir convertRelationDir((RelationDir) `one`) = \one();
public RelationDir convertRelationDir((RelationDir) `many`) = many();


public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as><AccessProperties accessProperties>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", convertAccessProperties(accessProperties));

public Declaration convertDeclaration((Declaration) `relation <RelationDir l>:<RelationDir r><ArtifactName entity>as<MemberName as>;`, _) 
    = relation(convertRelationDir(l), convertRelationDir(r), "<entity>", "<as>", {});


public set[AccessProperty] convertAccessProperties((AccessProperties) `with { <{AccessProperty ","}* props> }`)
    = {convertAccessProperty(p) | p <- props};

public AccessProperty convertAccessProperty((AccessProperty) `get`) = get();
public AccessProperty convertAccessProperty((AccessProperty) `set`) = \set();
public AccessProperty convertAccessProperty((AccessProperty) `add`) = add();
public AccessProperty convertAccessProperty((AccessProperty) `clear`) = clear();
public AccessProperty convertAccessProperty((AccessProperty) `reset`) = clear();


public str convertStringQuoted((StringQuoted) `"<StringCharacter* string>"`) = "<string>";


public Type convertType((Type) `int`) = integer();
public Type convertType((Type) `float`) = float();
public Type convertType((Type) `bool`) = boolean();
public Type convertType((Type) `boolean`) = boolean();
public Type convertType((Type) `void`) = voidValue();
public Type convertType((Type) `string`) = string();
public Type convertType((Type) `<Type t>[]`) = typedArray(convertType(t));
public Type convertType((Type) `<ArtifactName name>`) = artifactType("<name>");


public Expression convertWhen((When) `when <Expression expr>`) = convertExpression(expr);


public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name>`) = param(convertType(paramType), "<name>");

public Declaration convertParameter((Parameter) `<Type paramType> <MemberName name> <ParameterDefaultValue defaultValue>`) 
    = param(convertType(paramType), "<name>", convertParameterDefaultVal(defaultValue));

public Expression convertParameterDefaultVal((ParameterDefaultValue) `=<DefaultValue defaultValue>`)
    = convertExpression(defaultValue);
    


public Expression convertAssignable((Assignable) `<MemberName name>`) = variable("<name>");
public Expression convertAssignable((Assignable) `<Assignable variable>[<Expression key>]`)
    = arrayAccess(convertAssignable(variable), convertExpression(key));