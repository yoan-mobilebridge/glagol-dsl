module Transform::Glagol2PHP::Utils

import Transform::Env;
import Transform::Glagol2PHP::Annotations;
import Transform::Glagol2PHP::Common;
import Transform::Glagol2PHP::Constructors;
import Transform::Glagol2PHP::Methods;
import Transform::Glagol2PHP::Statements;
import Transform::Glagol2PHP::Properties;
import Transform::Glagol2PHP::ClassItems;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Config::Config;

public PhpStmt toPhpClassDef(u: util(str name, list[Declaration] declarations), TransformEnv env)
    = phpClassDef(phpClass(name, {}, phpNoName(), [], toPhpClassItems(declarations, env))[
        @phpAnnotations=toPhpAnnotations(u, env)
    ]);
