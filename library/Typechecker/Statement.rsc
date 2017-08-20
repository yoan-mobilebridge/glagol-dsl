module Typechecker::Statement

import Typechecker::Env;
import Typechecker::Errors;
import Typechecker::Expression;
import Typechecker::Type;
import Syntax::Abstract::Glagol;

import IO;

public TypeEnv checkStatements(list[Statement] stmts, t, subroutine, TypeEnv env) = 
	(env | checkStatement(stmt, t, subroutine, it) | stmt <- stmts);

public TypeEnv checkStatement(r: \return(Expression expr), \any(), action(_, _, _), TypeEnv env) = checkExpression(expr, env);
public TypeEnv checkStatement(r: \return(emptyExpr()), t, s, TypeEnv env) = checkReturn(voidValue(), externalize(t, env), r, env);
public TypeEnv checkStatement(r: \return(Expression expr), t, s, TypeEnv env) = checkReturn(lookupType(expr, env), externalize(t, env), r, checkExpression(expr, env));

public TypeEnv checkStatement(emptyStmt(), _, _, TypeEnv env) = env;

public TypeEnv checkReturn(Type actualType, Type expectedType, Statement r, TypeEnv env) = 
	addError(r, "Returning <toString(actualType)>, <toString(expectedType)> expected", env)
	when !isCompatibleForReturn(externalize(actualType, env), externalize(expectedType, env));
	
private bool isCompatibleForReturn(\list(voidValue()), \list(_)) = true;
private bool isCompatibleForReturn(\map(voidValue(), voidValue()), \map(_, _)) = true;
private bool isCompatibleForReturn(Type actualType, Type expectedType) = actualType == expectedType;
	
public TypeEnv checkReturn(Type actualType, Type expectedType, Statement r, TypeEnv env) = env;

public TypeEnv checkStatement(block(list[Statement] stmts), t, s, env) = checkStatements(stmts, t, s, env);
public TypeEnv checkStatement(expression(expr), t, s, env) = checkExpression(expr, env);
public TypeEnv checkStatement(ifThen(condition, then), t, s, env) = checkStatement(then, t, s, checkCondition(condition, env));
public TypeEnv checkStatement(ifThenElse(condition, then, \else), t, s, env) = 
	checkStatement(\else, t, s, checkStatement(then, t, s, checkCondition(condition, env)));
	
public TypeEnv checkStatement(a: assign(fieldAccess(this(), GlagolID name), _, _), t, subroutine, TypeEnv env) = 
	addError(a, "Value objects are immutable. You can only assign property values from the constructor", env)
	when isValueObject(env) && constructor(_, _, _) !:= subroutine && hasLocalProperty(name, env);
	
public TypeEnv checkStatement(a: assign(fieldAccess(Expression prev, GlagolID name), _, _), t, subroutine, TypeEnv env) = 
	addError(a, "Value objects are immutable. You can only assign property values from the constructor", env)
	when isValueObject(env) && constructor(_, _, _) !:= subroutine && sameAs(externalize(lookupType(prev, env), env), contextAsType(env), env);

public bool sameAs(Type: repository(Name first), Type: repository(Name second), TypeEnv env) = sameAs(first, second);
public bool sameAs(Type: artifact(Name first), Type: artifact(Name second), TypeEnv env) = sameAs(first, second);

public bool sameAs(external(_, Declaration namespace, str originalName), external(_, Declaration namespaceT, str originalNameT)) =
	namespace == namespaceT && originalName == originalNameT;
	
public bool sameAs(Name first, Name second) = false;
public bool sameAs(Type first, Type second, TypeEnv env) = false;
	
public TypeEnv checkStatement(a: assign(variable(GlagolID name), _, _), t, subroutine, TypeEnv env) = 
	addError(a, "Value objects are immutable. You can only assign property values from the constructor", env)
	when isValueObject(env) && constructor(_, _, _) !:= subroutine && isField(name, env);

public TypeEnv checkStatement(a: assign(assignable, operator, val), t, s, env) = 
	checkAssignType(a, lookupType(assignable, env), lookupType(val, env), checkAssignable(assignable, checkStatement(val, t, s, env)));

public TypeEnv checkAssignType(Statement s, \list(_), \list(voidValue()), TypeEnv env) = env;
public TypeEnv checkAssignType(Statement s, \map(_, _), \map(voidValue(), voidValue()), TypeEnv env) = env;
public TypeEnv checkAssignType(Statement s, artifact(_), self(), TypeEnv env) = env;
public TypeEnv checkAssignType(Statement s, repository(_), self(), TypeEnv env) = env;
	
public TypeEnv checkAssignType(Statement s, Type expectedType, Type actualType, TypeEnv env) =
	addError(s,
		"Cannot assign value of type <toString(actualType)> to a variable of type " + 
		"<toString(expectedType)>", env)
	when expectedType != actualType;

public TypeEnv checkAssignType(a: assign(assignable, operator, val), Type expectedType, Type actualType, TypeEnv env) = 
	addError(a, "Assignment operator not allowed", env)
	when !isOperatorAllowed(expectedType, operator);

public TypeEnv checkAssignType(Statement s, Type expectedType, Type actualType, TypeEnv env) = env;

public bool isOperatorAllowed(Type, defaultAssign()) = true;
public bool isOperatorAllowed(integer(), AssignOperator) = true;
public bool isOperatorAllowed(float(), AssignOperator) = true;
public bool isOperatorAllowed(string(), additionAssign()) = true;
public bool isOperatorAllowed(\list(Type \type), additionAssign()) = true;
public bool isOperatorAllowed(Type, AssignOperator) = false;

public TypeEnv checkAssignable(v: variable(_), TypeEnv env) = checkExpression(v, env);
public TypeEnv checkAssignable(f: fieldAccess(_), TypeEnv env) = checkExpression(f, env);
public TypeEnv checkAssignable(f: fieldAccess(_, _), TypeEnv env) = checkExpression(f, env);
public TypeEnv checkAssignable(a: arrayAccess(_, _), TypeEnv env) = checkExpression(a, env);
public TypeEnv checkAssignable(e, TypeEnv env) = addError(e, "Cannot assign value to expression", env);

public TypeEnv checkConditions(list[Expression] conditions, TypeEnv env) = (env | checkCondition(c, it) | c <- conditions);

public TypeEnv checkStatement(emptyStmt(), _, _, TypeEnv env) = env;
public TypeEnv checkStatement(p: persist(Expression expr), _, _, TypeEnv env) = checkORMFunction(p, env);
public TypeEnv checkStatement(p: flush(Expression expr), _, _, TypeEnv env) = checkORMFunction(p, env);
public TypeEnv checkStatement(p: remove(Expression expr), _, _, TypeEnv env) = checkORMFunction(p, env);

public TypeEnv checkORMFunction(Statement p, env) = checkIsContextARepository(getContext(env), p, env) when emptyExpr() := p.expr;
public TypeEnv checkORMFunction(Statement p, env) = checkIsContextARepository(getContext(env), p, checkIsSubjectAnEntity(lookupType(p.expr, env), p, env));

public TypeEnv checkIsSubjectAnEntity(t: artifact(_), p, env) = env when isEntity(t, env);
public TypeEnv checkIsSubjectAnEntity(_, p, env) = addError(p, "Only entities can be <stringify(p)>", env);

public TypeEnv checkIsContextARepository(\module(_, _, repository(_, _)), p, TypeEnv env) = env;
public TypeEnv checkIsContextARepository(c, p, TypeEnv env) = addError(p, "Entities can only be <stringify(p)> from within a repository", env);

public TypeEnv checkStatement(d: declare(_, Expression varName, _), _,  _, TypeEnv env) = 
	addError(d, "Cannot resolve variable name", env)
	when variable(_) !:= varName;

public TypeEnv checkStatement(d: declare(Type varType, variable(GlagolID name), emptyStmt()), t, s, TypeEnv env) = 
	checkType(varType, s, addDefinition(d, env));

public TypeEnv checkStatement(d: declare(Type varType, variable(GlagolID name), Statement defaultValue), t, s, TypeEnv env) = 
	checkStatement(defaultValue, t, s, checkDeclareType(varType, lookupType(defaultValue, env), name, d, addDefinition(d, env)));

public TypeEnv checkDeclareType(\list(_), \list(voidValue()), GlagolID name, d, TypeEnv env) = env;
public TypeEnv checkDeclareType(\map(_, _), \map(voidValue(), voidValue()), GlagolID name, d, TypeEnv env) = env;
public TypeEnv checkDeclareType(artifact(_), self(), GlagolID name, d, TypeEnv env) = env;
public TypeEnv checkDeclareType(repository(_), self(), GlagolID name, d, TypeEnv env) = env;

public TypeEnv checkDeclareType(Type expectedType, Type actualType, GlagolID name, d, TypeEnv env) = 
	addError(d,
		"Cannot assign <toString(actualType)> to variable <name> originally defined as <toString(expectedType)>", env)
	when expectedType != actualType;
	
public TypeEnv checkDeclareType(Type expectedType, Type actualType, GlagolID name, d, TypeEnv env) = env;

public Type lookupType(expression(Expression expr), TypeEnv env) = lookupType(expr, env);
public Type lookupType(assign(_, _, Statement \value), TypeEnv env) = lookupType(\value, env);
public Type lookupType(Statement, TypeEnv env) = unknownType();

private str stringify(persist(Expression expr)) = "persisted";
private str stringify(flush(Expression expr)) = "flushed";
private str stringify(remove(Expression expr)) = "removed";

public TypeEnv checkStatement(f: foreach(_, _, _, Statement body, _), t, s, TypeEnv env) = 
	decrementControlLevel(checkStatement(body, t, s, incrementControlLevel(checkForeach(f, env))));

public TypeEnv checkForeach(f: foreach(Expression \list, Expression key, Expression varName, Statement body, list[Expression] conditions), TypeEnv env) = 
	checkConditions(conditions, checkForeachTypes(lookupType(\list, env), key, varName, env));

public TypeEnv checkForeachTypes(l: \list(_), Expression key, Expression var, TypeEnv env) = 
	checkIsVarCompatibleWithCollection(l, var, checkIsKeyCompatibleWithCollection(l, key, env));
	
public TypeEnv checkForeachTypes(m: \map(_, _), Expression key, Expression var, TypeEnv env) = 
	checkIsVarCompatibleWithCollection(m, var, checkIsKeyCompatibleWithCollection(m, key, env));
	
public TypeEnv checkForeachTypes(Type t, Expression key, Expression var, TypeEnv env) = 
	addError(var, "Cannot traverse <toString(t)>", env);

public TypeEnv checkIsVarCompatibleWithCollection(\list(Type t), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as value in list traversing: already decleared and is not <toString(t)>", env)
	when isDefined(v, env) && lookupType(v, env) != t;

public TypeEnv checkIsVarCompatibleWithCollection(\list(Type t), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == t;
	
public TypeEnv checkIsVarCompatibleWithCollection(\list(Type t), v: variable(name), TypeEnv env) = 
	addDefinition(declare(t, v, emptyStmt())[@src=v@src], env);
	
public TypeEnv checkIsVarCompatibleWithCollection(\map(_, Type t), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as value in map traversing: already decleared and is not <toString(t)>", env)
	when isDefined(v, env) && lookupType(v, env) != t;

public TypeEnv checkIsVarCompatibleWithCollection(\map(_, Type t), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == t;
	
public TypeEnv checkIsVarCompatibleWithCollection(\map(_, Type t), v: variable(name), TypeEnv env) = 
	addDefinition(declare(t, v, emptyStmt())[@src=v@src], env);

public TypeEnv checkIsKeyCompatibleWithCollection(\list(_), emptyExpr(), TypeEnv env) = env;
public TypeEnv checkIsKeyCompatibleWithCollection(\list(_), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as key in list traversing: already decleared and it is not an integer", env) 
	when isDefined(v, env) && lookupType(v, env) != integer();
	
public TypeEnv checkIsKeyCompatibleWithCollection(\list(_), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == integer();
	
public TypeEnv checkIsKeyCompatibleWithCollection(\list(_), v: variable(name), TypeEnv env) = 
	addDefinition(declare(integer(), v, emptyStmt())[@src=v@src], env);
	
public TypeEnv checkIsKeyCompatibleWithCollection(\map(_, _), emptyExpr(), TypeEnv env) = env;
public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, _), v: variable(name), TypeEnv env) = 
	addError(v, "Cannot use <name> as key in map traversing: already decleared and it is not an <toString(key)>", env) 
	when isDefined(v, env) && lookupType(v, env) != key;

public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, _), v: variable(name), TypeEnv env) = 
	env when isDefined(v, env) && lookupType(v, env) == key;

public TypeEnv checkIsKeyCompatibleWithCollection(\map(Type key, _), v: variable(name), TypeEnv env) = 
	addDefinition(declare(key, v, emptyStmt())[@src=v@src], env);

public TypeEnv checkIsKeyCompatibleWithCollection(_, _, TypeEnv env) = env;

public TypeEnv checkStatement(b: \break(0), t, s, TypeEnv env) = 
	addError(b, "Cannot break out from structure using level 0", env);
	
public TypeEnv checkStatement(b: \break(int level), t, s, TypeEnv env) = 
	addError(b, "Cannot break out from structure using level <level>", env)
	when !isControlLevelCorrect(level, env);
	
public TypeEnv checkStatement(b: \break(int level), t, s, TypeEnv env) = env;

public TypeEnv checkStatement(c: \continue(0), t, s, TypeEnv env) = 
	addError(c, "Cannot continue from structure using level 0", env);
	
public TypeEnv checkStatement(c: \continue(int level), t, s, TypeEnv env) = 
	addError(c, "Cannot continue from structure using level <level>", env)
	when !isControlLevelCorrect(level, env);
	
public TypeEnv checkStatement(c: \continue(int level), t, s, TypeEnv env) = env;

/*
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;
public TypeEnv checkStatement() = ;*/