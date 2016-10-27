module Transform::Glagol2PHP::Constructors

import Transform::Glagol2PHP::Params;
//import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Expressions;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import IO;

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [toPhpStmt(stmt) | stmt <- body]);

public PhpClassItem toPhpClassItem(constructor(list[Declaration] params, list[Statement] body, Expression when)) 
    = phpMethod("__construct", {phpPublic()}, false, [toPhpParam(p) | p <- params], [
        phpIf(toPhpExpr(when), [toPhpStmt(stmt) | stmt <- body], [], phpNoElse())
    ]);

public list[Declaration] getConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_,_) := c || constructor(_, _, _) := c];
    
public list[Declaration] getNonConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_,_) !:= c && constructor(_, _, _) !:= c];

public list[Declaration] getConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _, _) := c];

public list[Declaration] getNonConditionalConstructors(list[Declaration] declarations)
    = [c | c <- declarations, constructor(_, _) !:= c];

public PhpClassItem createOverridedConstructor(list[Declaration] declarations)
    = phpMethod("__construct", {phpPublic()}, false, [phpParam("args", phpNoExpr(), phpNoName(), false, true)], [
        phpExprstmt(phpAssign(phpVar(phpName(phpName("overrider"))), phpNew(phpName(phpName("Overrider")), [])))
    ] + [createOverrideRule(d) | d <- declarations]);

private PhpStmt createOverrideRule(constructor(list[Declaration] params, list[Statement] body))
    = phpExprstmt(phpMethodCall(
        phpVar(phpName(phpName("overrider"))), phpName(phpName("override")), [
            phpActualParameter(phpClosure([toPhpStmt(stmt) | stmt <- body], [toPhpParam(p) | p <- params], [], false, false), false)
        ] + [phpActualParameter(createOverrideType(p), false) | p <- params]
    ));
    
private PhpStmt createOverrideRule(constructor(list[Declaration] params, list[Statement] body, Expression when))
    = phpIf(toPhpExpr(when), [createOverrideRule(constructor(params, body))], [], phpNoElse());
    
private PhpExpr createOverrideType(param(integer(), _)) = phpNew(phpName(phpName("Parameter\\Integer")), []);
private PhpExpr createOverrideType(param(float(), _)) = phpNew(phpName(phpName("Parameter\\Real")), []);
private PhpExpr createOverrideType(param(string(), _)) = phpNew(phpName(phpName("Parameter\\Str")), []);
private PhpExpr createOverrideType(param(boolean(), _)) = phpNew(phpName(phpName("Parameter\\Boolean")), []);
private PhpExpr createOverrideType(param(typedList(Type \type), _)) = phpNew(phpName(phpName("Parameter\\TypedList")), [
    phpActualParameter(createOverrideType(\type), false)
]);
private PhpExpr createOverrideType(param(typedMap(Type key, Type v), _)) = phpNew(phpName(phpName("Parameter\\Map")), [
    phpActualParameter(createOverrideType(key), false), phpActualParameter(createOverrideType(v), false)
]);
private PhpExpr createOverrideType(param(artifactType(str name), _)) = phpNew(phpName(phpName("Parameter\\Custom")), [
    phpActualParameter(phpScalar(phpString(name)), false)
]);
private PhpExpr createOverrideType(param(repositoryType(str name), _)) = phpNew(phpName(phpName("Parameter\\Custom")), [
    phpActualParameter(phpScalar(phpString(name + "Repository")), false)
]);
