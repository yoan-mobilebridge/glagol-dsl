module Test::Transform::Glagol2PHP::Statements

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Statements;

test bool shouldTransformToIfWithoutElse() = 
    toPhpStmt(ifThen(greaterThan(integer(21), variable("input")), expression(invoke("myFunc", [
        variable("input")
    ]))), newTransformEnv()) ==
    phpIf(
        phpBinaryOperation(phpScalar(phpInteger(21)), phpVar(phpName(phpName("input"))), phpGt()),
        [
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("myFunc")), [
                phpActualParameter(phpVar(phpName(phpName("input"))), false)
            ]))
        ], [], phpNoElse()
    );

test bool shouldTransformToAnExpression() = 
    toPhpStmt(expression(greaterThanOrEq(float(1.32), variable("input"))), newTransformEnv()) ==
    phpExprstmt(phpBinaryOperation(phpScalar(phpFloat(1.32)), phpVar(phpName(phpName("input"))), phpGeq()));
    
test bool shouldTransformToABlock() =
    toPhpStmt(block([
        expression(greaterThanOrEq(variable("input"), string("blah"))),
        expression(equals(float(1.32), variable("input")))
    ]), newTransformEnv()) ==
    phpBlock([
        phpExprstmt(phpBinaryOperation(phpVar(phpName(phpName("input"))), phpScalar(phpString("blah")), phpGeq())),
        phpExprstmt(phpBinaryOperation(phpScalar(phpFloat(1.32)), phpVar(phpName(phpName("input"))), phpIdentical()))
    ]);

test bool shouldTransformToIfThenElse() =
    toPhpStmt(ifThenElse(equals(string("SOME_CONST"), variable("input")), expression(invoke("someFunc", [])), expression(invoke("someOtherFunc", []))), newTransformEnv()) ==
    phpIf(
        phpBinaryOperation(phpScalar(phpString("SOME_CONST")), phpVar(phpName(phpName("input"))), phpIdentical()),
        [
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("someFunc")), []))
        ], [], phpSomeElse(phpElse([
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("someOtherFunc")), []))
        ]))
    );

test bool shouldTransformToAssignUsingDefaultOperator() =
    toPhpStmt(assign(variable("trackID"), defaultAssign(), expression(integer(89))), newTransformEnv()) == 
    phpExprstmt(phpAssign(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89))));

test bool shouldTransformToAssignUsingDivisionOperator() =
    toPhpStmt(assign(variable("trackID"), divisionAssign(), expression(integer(89))), newTransformEnv()) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpDiv()));

test bool shouldTransformToAssignUsingProductOperator() =
    toPhpStmt(assign(variable("trackID"), productAssign(), expression(integer(89))), newTransformEnv()) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpMul()));
    
test bool shouldTransformToAssignUsingSubOperator() =
    toPhpStmt(assign(variable("trackID"), subtractionAssign(), expression(integer(89))), newTransformEnv()) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpMinus()));
    
test bool shouldTransformToAssignUsingAddOperator() =
    toPhpStmt(assign(variable("trackID"), additionAssign(), expression(integer(89))), newTransformEnv()) == 
    phpExprstmt(phpAssignWOp(phpVar(phpName(phpName("trackID"))), phpScalar(phpInteger(89)), phpPlus()));

test bool shouldTransformToReturnStmt() =
    toPhpStmt(\return(variable("output")), newTransformEnv()) ==
    phpReturn(phpSomeExpr(phpVar(phpName(phpName("output")))));

test bool shouldTransformToEmptyReturnStmt() = toPhpStmt(\return(emptyExpr()), newTransformEnv()) == phpReturn(phpNoExpr());

test bool shouldTransformToNulledDeclaration() =
    toPhpStmt(declare(integer(), variable("var1"), emptyStmt()), newTransformEnv()) ==
    phpExprstmt(phpAssign(phpVar(phpName(phpName("var1"))), phpScalar(phpNull())));
    
test bool shouldTransformToDeclarationWithDefaultValue() =
    toPhpStmt(declare(integer(), variable("var1"), expression(integer(23))), newTransformEnv()) ==
    phpExprstmt(phpAssign(phpVar(phpName(phpName("var1"))), phpScalar(phpInteger(23))));
    
test bool shouldTransformToDeclarationWithAssignAsDefaultValue() =
    toPhpStmt(declare(integer(), variable("var1"), assign(variable("var2"), defaultAssign(), expression(integer(44)))), newTransformEnv()) ==
    phpExprstmt(phpAssign(phpVar(phpName(phpName("var1"))), phpAssign(phpVar(phpName(phpName("var2"))), phpScalar(phpInteger(44)))));

test bool shouldTransformToForeach() = 
    toPhpStmt(foreach(variable("categories"), emptyExpr(), variable("category"), expression(invoke("func", [])), []), newTransformEnv()) ==
    phpForeach(
        phpVar(phpName(phpName("categories"))), 
        phpNoExpr(), false, phpVar(phpName(phpName("category"))), [
            phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("func")), []))
        ]
    );

test bool shouldTransformToForeachWithConditions() = 
    toPhpStmt(foreach(variable("categories"), emptyExpr(), variable("category"), expression(invoke("func", [])), [boolean(true)]), newTransformEnv()) ==
    phpForeach(
        phpVar(phpName(phpName("categories"))), 
        phpNoExpr(), false, phpVar(phpName(phpName("category"))), [
            phpIf(phpScalar(phpBoolean(true)), [
                phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("func")), []))
            ], [], phpNoElse())
        ]
    );

test bool shouldTransformToForeachWithConditions2() = 
    toPhpStmt(foreach(variable("categories"), emptyExpr(), variable("category"), expression(invoke("func", [])), [boolean(true), boolean(true)]), newTransformEnv()) ==
    phpForeach(
        phpVar(phpName(phpName("categories"))), 
        phpNoExpr(), false, phpVar(phpName(phpName("category"))), [
            phpIf(phpBinaryOperation(phpScalar(phpBoolean(true)), phpScalar(phpBoolean(true)), phpLogicalAnd()), [
                phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("func")), []))
            ], [], phpNoElse())
        ]
    );

test bool shouldTransformToForeachWithConditions3() = 
    toPhpStmt(foreach(variable("categories"), emptyExpr(), variable("category"), expression(invoke("func", [])), [boolean(true), boolean(true), boolean(true)]), newTransformEnv()) ==
    phpForeach(
        phpVar(phpName(phpName("categories"))), 
        phpNoExpr(), false, phpVar(phpName(phpName("category"))), [
            phpIf(phpBinaryOperation(phpScalar(phpBoolean(true)), phpBinaryOperation(phpScalar(phpBoolean(true)), phpScalar(phpBoolean(true)), phpLogicalAnd()), phpLogicalAnd()), [
                phpExprstmt(phpMethodCall(phpVar(phpName(phpName("this"))), phpName(phpName("func")), []))
            ], [], phpNoElse())
        ]
    );
    
test bool shouldTransformToEntityManagerPersist() =
    toPhpStmt(persist(variable("entity")), newTransformEnv()) == phpExprstmt(phpMethodCall(phpPropertyFetch(
        phpVar(phpName(phpName("this"))), phpName(phpName("_em"))
    ), phpName(phpName("persist")), [
        phpActualParameter(phpVar(phpName(phpName("entity"))), false)
    ]));
    
test bool shouldTransformToEntityManagerRemove() =
    toPhpStmt(remove(variable("entity")), newTransformEnv()) == phpExprstmt(phpMethodCall(phpPropertyFetch(
        phpVar(phpName(phpName("this"))), phpName(phpName("_em"))
    ), phpName(phpName("remove")), [
        phpActualParameter(phpVar(phpName(phpName("entity"))), false)
    ]));
    
test bool shouldTransformToEntityManagerFlushWithoutArgs() =
    toPhpStmt(flush(emptyExpr()), newTransformEnv()) == phpExprstmt(phpMethodCall(phpPropertyFetch(
        phpVar(phpName(phpName("this"))), phpName(phpName("_em"))
    ), phpName(phpName("flush")), []));
    
test bool shouldTransformToEntityManagerFlushWithArgument() =
    toPhpStmt(flush(variable("entity")), newTransformEnv()) == phpExprstmt(phpMethodCall(phpPropertyFetch(
        phpVar(phpName(phpName("this"))), phpName(phpName("_em"))
    ), phpName(phpName("flush")), [
        phpActualParameter(phpVar(phpName(phpName("entity"))), false)
    ]));

test bool shouldTransformToContinue() =
    toPhpStmt(\continue(1), newTransformEnv()) == phpContinue(phpNoExpr());
    
test bool shouldTransformToContinue2() =
    toPhpStmt(\continue(2), newTransformEnv()) == phpContinue(phpSomeExpr(phpScalar(phpInteger(2))));
    
test bool shouldTransformToBreak() =
    toPhpStmt(\break(1), newTransformEnv()) == phpBreak(phpNoExpr());
    
test bool shouldTransformToBreak2() =
    toPhpStmt(\break(2), newTransformEnv()) == phpBreak(phpSomeExpr(phpScalar(phpInteger(2))));
