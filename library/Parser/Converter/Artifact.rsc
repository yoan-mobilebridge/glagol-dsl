module Parser::Converter::Artifact

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Concrete::Grammar;
import Parser::Converter::Declaration::Constructor;
import Parser::Converter::Declaration::Method;
import Parser::Converter::Annotation;

public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Artifact artifact>`, ParseEnv env) = 
	convertArtifact(artifact, env);
    
public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Annotation* annotations><Artifact artifact>`, ParseEnv env) = 
	convertArtifact(artifact, env)[
    	@annotations = convertAnnotations(annotations, env)
    ];

public Declaration convertArtifact(a: (Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	entity("<name>", [convertDeclaration(d, "<name>", "entity", env) | d <- declarations])[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) =
	repository("<name>", [convertDeclaration(d, "<name>", "repository", env) | d <- declarations] + defaultRepositoryMethod("<name>", a@\loc, env))[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `value <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	valueObject("<name>", [convertDeclaration(d, "<name>", "value", env) | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `util <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	util("<name>", [convertDeclaration(d, "<name>", "util", env) | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `service <ArtifactName name> {<Declaration* declarations>}`, ParseEnv env) = 
	util("<name>", [convertDeclaration(d, "<name>", "util", env) | d <- declarations])[@src=a@\loc];

public ControllerType convertControllerType(c: (ControllerType) `json-api`) = jsonApi()[@src=c@\loc];
public ControllerType convertControllerType(c: (ControllerType) `rest`) = jsonApi()[@src=c@\loc];

public Route convertRoute(r: (RoutePart) `<Identifier part>`) = routePart("<part>")[@src=r@\loc];
public Route convertRoute(r: (RoutePart) `<RoutePlaceholder placeholder>`) = 
	routeVar(substring("<placeholder>", 1, size("<placeholder>")))[@src=r@\loc];

public str createControllerName(loc file) {
	str name = substring(file.file, 0, size(file.file) - size(file.extension) - 1);
	
	if (/^[A-Z][a-zA-Z]+?Controller$/ !:= name) {
		throw IllegalControllerName("Controller file name <name> does not follow the pattern `^[A-Z][a-zA-Z]+?Controller$`", file);
	}
	
	return name;
}

public Route convertRoute(ro: (Route) `/<{RoutePart "/"}* routes>`) = route([convertRoute(r) | r <- routes])[@src=ro@\loc];

public Declaration convertArtifact(a: (Artifact) `<ControllerType controllerType>controller<Route r>{<Declaration* declarations>}`, ParseEnv env) = 
	controller(
		createControllerName(a@\loc),
		convertControllerType(controllerType), 
		convertRoute(r), 
		[convertDeclaration(d, "", "controller", env) | d <- declarations]
	)[@src=a@\loc];

private list[Declaration] defaultRepositoryMethod(str name, loc src, ParseEnv env) = [
	method(\public()[@src=src], artifact(createName(name, env)[@src=src])[@src=src], "find", [
		param(integer()[@src=src], "id", emptyExpr()[@src=src])[@src=src]
	], [\return(new(createName(name, env)[@src=src], [])[@src=src])[@src=src]], emptyExpr()[@src=src])[@src=src],
	method(\public()[@src=src], \list(artifact(createName(name, env)[@src=src])[@src=src])[@src=src], "findAll", [], 
		[\return(\list([])[@src=src])[@src=src]], emptyExpr()[@src=src])[@src=src]
];
