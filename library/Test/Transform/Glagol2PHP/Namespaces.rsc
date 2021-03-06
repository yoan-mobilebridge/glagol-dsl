module Test::Transform::Glagol2PHP::Namespaces

import Transform::Glagol2PHP::Namespaces;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;
import Transform::Env;

test bool shouldTransformToAPhpNamespace() = 
	toPhpNamespace(\module(namespace("Test", namespace("Entity", namespace("User"))), 
		[], entity("User", [])), [], newTransformEnv()) == 
	phpNamespace(
	  phpSomeName(phpName("Test\\Entity\\User")),
	  [
	    phpUse({
            phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
            phpUse(phpName("Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait"), phpNoName()),
            phpUse(phpName("Glagol\\Helper\\Entity\\HydrateTrait"), phpNoName())
        }),
	    phpClassDef(phpClass(
	        "User",
	        {},
	        phpNoName(),
	        [phpName("\\JsonSerializable")],
	        [phpTraitUse(
                [
                  phpName("JsonSerializeTrait"),
                  phpName("HydrateTrait")
                ],
                [])]))
	  ]) && toPhpNamespace(\module(namespace("Test", namespace("Entity", namespace("User"))), 
		[], entity("User", [])), [], newTransformEnv()).body[1].classDef@phpAnnotations == 
		{phpAnnotation("ORM\\Entity")};

		
test bool shouldTransformSimpleEntityToPhpScriptUsingDoctrine()
    = toPHPScript(newTransformEnv(), \module(namespace("User", namespace("Entity")), [
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    ], entity("Customer", [
        property(integer(), "id", emptyExpr())
    ])), [])
    == ("User/Entity/Customer.php": phpScript([
    	phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], []),
        phpNamespace(phpSomeName(phpName("User\\Entity")), [
            phpUse({
                phpUse(phpName("Currency\\Value\\Money"), phpNoName()),
                phpUse(phpName("Currency\\Value\\Currency"), phpSomeName(phpName("CurrencyVB"))),
                phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
                phpUse(phpName("Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait"), phpNoName()),
                phpUse(phpName("Glagol\\Helper\\Entity\\HydrateTrait"), phpNoName())
            }),
            phpClassDef(phpClass(
                "Customer", {}, phpNoName(), [phpName("\\JsonSerializable")], [
                    phpTraitUse([phpName("JsonSerializeTrait"), phpName("HydrateTrait")], []),
                    phpProperty({phpPrivate()}, [phpProperty("id", phpNoExpr())])
                ]
            ))
        ])
    ]));

test bool shouldTransformSimpleAnnotatedEntityToPhpScriptUsingDoctrine()
    = toPHPScript(newTransformEnv(), \module(namespace("User", namespace("Entity")), [
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    ], entity("Customer", [
        property(integer(), "id", emptyExpr())
    ])[@annotations=[annotation("table", [])]]), [])
    == ("User/Entity/Customer.php": phpScript([
    	phpDeclare([phpDeclaration("strict_types", phpScalar(phpInteger(1)))], []),
        phpNamespace(phpSomeName(phpName("User\\Entity")), [
            phpUse({
                phpUse(phpName("Currency\\Value\\Money"), phpNoName()),
                phpUse(phpName("Currency\\Value\\Currency"), phpSomeName(phpName("CurrencyVB"))),
                phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
                phpUse(phpName("Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait"), phpNoName()),
                phpUse(phpName("Glagol\\Helper\\Entity\\HydrateTrait"), phpNoName())
            }),
            phpClassDef(phpClass(
                "Customer", {}, phpNoName(), [phpName("\\JsonSerializable")], [
                    phpTraitUse([phpName("JsonSerializeTrait"), phpName("HydrateTrait")], []),
                    phpProperty({phpPrivate()}, [phpProperty("id", phpNoExpr())])
                ]
            ))
        ])
    ]));
    
test bool shouldTransformSimpleAnnotatedWithValueEntityToPhpScriptUsingDoctrine() {
    map[str, PhpScript] asts = toPHPScript(newTransformEnv(), \module(namespace("User", namespace("Entity")), [
        \import("Money", namespace("Currency", namespace("Value")), "Money"),
        \import("Currency", namespace("Currency", namespace("Value")), "CurrencyVB")
    ], entity("Customer", [
        property(integer(), "id", emptyExpr())[@annotations=[
            annotation("id", []),
            annotation("field", [
                annotationMap((
                    "name": annotationVal("customer_id"),
                    "type": annotationVal(integer()),
                    "length": annotationVal(11),
                    "unique": annotationVal(true),
                    "options": annotationVal(annotationMap((
                        "comment": annotationVal("This is the primary key")
                    ))),
                    "scale": annotationVal(12.35)
                ))
            ])
        ]]
    ])[@annotations=[annotation("table", [annotationVal("customers")])]]), []);
    
    PhpScript ast = asts["User/Entity/Customer.php"];
    
    return ast.body[1].body[1].classDef@phpAnnotations == {
              phpAnnotation("ORM\\Entity"),
              phpAnnotation(
                "ORM\\Table",
                phpAnnotationVal(("name":phpAnnotationVal("customers"))))
            } &&
           ast.body[1].body[1].classDef.members[1]@phpAnnotations == {
                  phpAnnotation(
                    "ORM\\Column",
                    phpAnnotationVal((
                        "name": phpAnnotationVal("customer_id"),
                        "type": phpAnnotationVal("integer"),
                        "length": phpAnnotationVal(11),
                        "unique": phpAnnotationVal(true),
                        "options": phpAnnotationVal((
                            "comment": phpAnnotationVal("This is the primary key")
                        )),
                        "scale": phpAnnotationVal(12.35)
                    ))),
                  phpAnnotation("ORM\\Id"),
                  phpAnnotation("var", phpAnnotationVal("integer"))
           };
}
