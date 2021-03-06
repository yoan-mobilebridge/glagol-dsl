module Test::Transform::Glagol2PHP::Imports

import Transform::Env;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Imports;
import Config::Config;

test bool shouldConvertToPhpUsesOnDoctrineEntityAndOverriding() =
	toPhpUses(\module(namespace("Example"), 
		[\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], [], emptyExpr()),
			constructor([], [], emptyExpr()),
			constructor([], [], emptyExpr())
		])), [], 
		newTransformEnv(anyFramework(), doctrine())) ==
	[phpUse({
		phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
		phpUse(phpName("Glagol\\Overriding\\Overrider"), phpNoName()),
        phpUse(phpName("Glagol\\Overriding\\Parameter"), phpNoName()),
        phpUse(phpName("Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait"), phpNoName()),
        phpUse(phpName("Glagol\\Helper\\Entity\\HydrateTrait"), phpNoName()),
        phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;

test bool shouldConvertToPhpUsesOnAnyORMEntityAndOverriding() =
	toPhpUses(
		\module(namespace("Example"), [\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], [], emptyExpr()),
			constructor([], [], emptyExpr()),
			constructor([], [], emptyExpr())
		])), [],
		newTransformEnv(anyFramework(), anyORM())) ==
	[phpUse({
		phpUse(phpName("Glagol\\Overriding\\Overrider"), phpNoName()),
		phpUse(phpName("Glagol\\Overriding\\Parameter"), phpNoName()),
		phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;

test bool shouldConvertToPhpUsesOnAnyORMEntityWithoutOverriding() =
	toPhpUses(\module(namespace("Example"), 
		[\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], [], emptyExpr())
		])), [], 
		newTransformEnv(anyFramework(), anyORM())) ==
	[phpUse({
		phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;
    
test bool shouldConvertToPhpUsesOnDoctrineEntityWithoutOverriding() =
    toPhpUses(\module(namespace("Example"), 
        [\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
        entity("User", [
            constructor([], [], emptyExpr())
        ])), [], 
        newTransformEnv(anyFramework(), doctrine())) ==
    [phpUse({
        phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
        phpUse(phpName("Foo\\Bar\\Blah"), phpNoName()),
        phpUse(phpName("Glagol\\Bridge\\Lumen\\Entity\\JsonSerializeTrait"), phpNoName()),
        phpUse(phpName("Glagol\\Helper\\Entity\\HydrateTrait"), phpNoName())
    })]
    ;
    
test bool shouldConvertToDsMapPhpUsesOnMapsAndMapTypes() =
    toPhpUses(\module(namespace("Example"), [], 
        entity("User", [
            property(\map(integer(), string()), "prop", emptyExpr())
        ])), [], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Ds\\Map"), phpNoName()),
        phpUse(phpName("Ds\\Pair"), phpNoName()),
        phpUse(phpName("Glagol\\Ds\\MapFactory"), phpNoName())
    })] && 
    toPhpUses(\module(namespace("Example"), [], 
        entity("User", [
            constructor([], [
                expression(\map(()))
            ], emptyExpr())
        ])), [], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Ds\\Map"), phpNoName()),
        phpUse(phpName("Ds\\Pair"), phpNoName()),
        phpUse(phpName("Glagol\\Ds\\MapFactory"), phpNoName())
    })]
    ;
    
test bool shouldConvertToDsMapPhpUsesOnListsAndListTypes() =
    toPhpUses(\module(namespace("Example"), [], 
        entity("User", [
            property(\list(integer()), "prop", emptyExpr())
        ])), [], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Ds\\Vector"), phpNoName())
    })] && 
    toPhpUses(\module(namespace("Example"), [], 
        entity("User", [
            constructor([], [
                expression(\list([]))
            ], emptyExpr())
        ])), [], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Ds\\Vector"), phpNoName())
    })]
    ;
    
test bool shouldIncludeRepositoryWhenUsed() =
    toPhpUses(\module(namespace("Example"), [
    		\import("User", namespace("Example", namespace("Entity")), "User")
    	], 
        util("UserCreator", [
            property(repository(fullName("User", namespace("Example"), "User")), "users", emptyExpr())
        ])), [
        	file(|tmp:///repo.g|, \module(namespace("Example", namespace("Repository")), [
		        \import("User", namespace("Example", namespace("Entity")), "User")
		    ], repository("User", []))),
        	file(|tmp:///entity.g|, \module(namespace("Example", namespace("Entity")), [
		    ], entity("User", [])))
        ], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Example\\Entity\\User"), phpNoName()),
        phpUse(phpName("Example\\Repository\\UserRepository"), phpNoName())
    })]
    ;
    
test bool shouldIncludeRepositoryWhenUsedWithAliases() =
    toPhpUses(\module(namespace("Example"), [
    		\import("User", namespace("Example", namespace("Entity")), "UserHa")
    	], 
        util("UserCreator", [
            property(repository(fullName("UserHa", namespace("Example"), "User")), "users", emptyExpr())
        ])), [
        	file(|tmp:///repo.g|, \module(namespace("Example", namespace("Repository")), [
		        \import("User", namespace("Example", namespace("Entity")), "UserBla")
		    ], repository("UserBla", []))),
        	file(|tmp:///entity.g|, \module(namespace("Example", namespace("Entity")), [
		    ], entity("User", [])))
        ], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Example\\Entity\\User"), phpSomeName(phpName("UserHa"))),
        phpUse(phpName("Example\\Repository\\UserRepository"), phpNoName())
    })]
    ;
    
test bool shouldIncludeRepositoriesWhenUsed() =
    toPhpUses(\module(namespace("Example"), [
    		\import("User", namespace("Example", namespace("Entity")), "User"),
    		\import("Customer", namespace("Example", namespace("Entity")), "Customer")
    	], 
        util("UserCreator", [
            property(repository(fullName("User", namespace("Example", namespace("Entity")), "User")), "users", emptyExpr()),
            property(repository(fullName("Customer", namespace("Example", namespace("Entity")), "Customer")), "customers", emptyExpr())
        ])), [
        	file(|tmp:///repo.g|, \module(namespace("Example", namespace("Repository")), [
		        \import("User", namespace("Example", namespace("Entity")), "User")
		    ], repository("User", []))),
        	file(|tmp:///entity.g|, \module(namespace("Example", namespace("Entity")), [
		    ], entity("User", []))),
        	file(|tmp:///repo.g|, \module(namespace("Example", namespace("Repository")), [
		        \import("Customer", namespace("Example", namespace("Entity")), "Customer")
		    ], repository("Customer", []))),
        	file(|tmp:///entity.g|, \module(namespace("Example", namespace("Entity")), [
		    ], entity("Customer", [])))
        ], 
        newTransformEnv(anyFramework(), anyORM())) ==
    [phpUse({
        phpUse(phpName("Example\\Entity\\User"), phpNoName()),
        phpUse(phpName("Example\\Repository\\UserRepository"), phpNoName()),
        phpUse(phpName("Example\\Entity\\Customer"), phpNoName()),
        phpUse(phpName("Example\\Repository\\CustomerRepository"), phpNoName())
    })]
    ;
    
