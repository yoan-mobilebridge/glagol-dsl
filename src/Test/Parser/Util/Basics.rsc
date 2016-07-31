module Test::Parser::Util::Basics

import Syntax::Abstract::AST;
import Parser::ParseAST;

test bool shouldParseEmptyUtil()
{
    str code 
        = "module Test;
          'util UserCreator {}";
          
    return parseModule(code) == \module("Test", {}, util("UserCreator", {}));
}

test bool shouldParseUtilUsingTheServiceKeyword()
{
    str code 
        = "module Test;
          'service UserCreator {}";
          
    return parseModule(code) == \module("Test", {}, util("UserCreator", {}));
}