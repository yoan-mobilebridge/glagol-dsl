module Test::Compiler::Laravel::Config::App

import Compiler::Laravel::Config::App;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Compiler::PHP::Compiler;
import lang::json::ast::JSON;
import Config::Reader;

test bool shouldGenerateLaravelAppConfig() = 
    createAppConfig(newConfig(), []) == 
    toCode(phpScript([phpReturn(phpSomeExpr(phpArray([
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("providers"))),
              phpArray([
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Auth\\AuthServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Broadcasting\\BroadcastServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Bus\\BusServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Cache\\CacheServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Foundation\\Providers\\ConsoleSupportServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Cookie\\CookieServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Database\\DatabaseServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Encryption\\EncryptionServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Filesystem\\FilesystemServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Foundation\\Providers\\FoundationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Hashing\\HashServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Mail\\MailServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Notifications\\NotificationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Pagination\\PaginationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Pipeline\\PipelineServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Queue\\QueueServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Redis\\RedisServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Auth\\Passwords\\PasswordResetServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Session\\SessionServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Translation\\TranslationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Validation\\ValidationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\View\\ViewServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Glagol\\Bridge\\Laravel\\Providers\\RouteServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("LaravelDoctrine\\ORM\\DoctrineServiceProvider")),
                      "class"),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("log"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_LOG")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("single")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("log_level"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_LOG_LEVEL")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("debug")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("env"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_ENV")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("production")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("url"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_URL")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("http://localhost")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("debug"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_DEBUG")),
                    false),
                  phpActualParameter(
                    phpScalar(phpBoolean(true)),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("fallback_locale"))),
              phpScalar(phpString("en")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("timezone"))),
              phpScalar(phpString("UTC")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("locale"))),
              phpScalar(phpString("en")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("aliases"))),
              phpArray([
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Bus"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Bus")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("View"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\View")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Auth"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Auth")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Route"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Route")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Queue"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Queue")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Validator"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Validator")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Session"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Session")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Mail"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Mail")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Blade"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Blade")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("DB"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\DB")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Eloquent"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Database\\Eloquent\\Model")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Response"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Response")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Schema"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Schema")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("App"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\App")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Cache"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Cache")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Config"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Config")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Cookie"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Cookie")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Log"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Log")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Gate"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Gate")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Notification"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Notification")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Hash"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Hash")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Crypt"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Crypt")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Lang"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Lang")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("URL"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\URL")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Request"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Request")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Event"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Event")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Artisan"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Artisan")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Redis"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Redis")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Storage"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Storage")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Password"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Password")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("File"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\File")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Redirect"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Redirect")),
                      "class"),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("key"))),
              phpCall(
                phpName(phpName("env")),
                [phpActualParameter(
                    phpScalar(phpString("APP_KEY")),
                    false)]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("cipher"))),
              phpScalar(phpString("AES-256-CBC")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("name"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_NAME")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("Glagol DSL project")),
                    false)
                ]),
              false)
          ])))]));

test bool shouldGenerateLaravelAppConfigHavingRepositoryProviders() = 
    createAppConfig(newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", [])))
    ]) == 
    toCode(phpScript([phpReturn(phpSomeExpr(phpArray([
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("providers"))),
              phpArray([
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Auth\\AuthServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Broadcasting\\BroadcastServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Bus\\BusServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Cache\\CacheServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Foundation\\Providers\\ConsoleSupportServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Cookie\\CookieServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Database\\DatabaseServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Encryption\\EncryptionServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Filesystem\\FilesystemServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Foundation\\Providers\\FoundationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Hashing\\HashServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Mail\\MailServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Notifications\\NotificationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Pagination\\PaginationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Pipeline\\PipelineServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Queue\\QueueServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Redis\\RedisServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Auth\\Passwords\\PasswordResetServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Session\\SessionServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Translation\\TranslationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Validation\\ValidationServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\View\\ViewServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("Glagol\\Bridge\\Laravel\\Providers\\RouteServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("LaravelDoctrine\\ORM\\DoctrineServiceProvider")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpNoExpr(),
                    phpFetchClassConst(
                      phpName(phpName("App\\Provider\\UserRepositoryProvider")),
                      "class"),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("log"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_LOG")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("single")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("log_level"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_LOG_LEVEL")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("debug")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("env"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_ENV")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("production")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("url"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_URL")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("http://localhost")),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("debug"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_DEBUG")),
                    false),
                  phpActualParameter(
                    phpScalar(phpBoolean(true)),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("fallback_locale"))),
              phpScalar(phpString("en")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("timezone"))),
              phpScalar(phpString("UTC")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("locale"))),
              phpScalar(phpString("en")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("aliases"))),
              phpArray([
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Bus"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Bus")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("View"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\View")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Auth"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Auth")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Route"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Route")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Queue"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Queue")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Validator"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Validator")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Session"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Session")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Mail"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Mail")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Blade"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Blade")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("DB"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\DB")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Eloquent"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Database\\Eloquent\\Model")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Response"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Response")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Schema"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Schema")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("App"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\App")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Cache"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Cache")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Config"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Config")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Cookie"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Cookie")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Log"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Log")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Gate"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Gate")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Notification"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Notification")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Hash"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Hash")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Crypt"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Crypt")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Lang"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Lang")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("URL"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\URL")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Request"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Request")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Event"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Event")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Artisan"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Artisan")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Redis"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Redis")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Storage"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Storage")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Password"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Password")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("File"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\File")),
                      "class"),
                    false),
                  phpArrayElement(
                    phpSomeExpr(phpScalar(phpString("Redirect"))),
                    phpFetchClassConst(
                      phpName(phpName("Illuminate\\Support\\Facades\\Redirect")),
                      "class"),
                    false)
                ]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("key"))),
              phpCall(
                phpName(phpName("env")),
                [phpActualParameter(
                    phpScalar(phpString("APP_KEY")),
                    false)]),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("cipher"))),
              phpScalar(phpString("AES-256-CBC")),
              false),
            phpArrayElement(
              phpSomeExpr(phpScalar(phpString("name"))),
              phpCall(
                phpName(phpName("env")),
                [
                  phpActualParameter(
                    phpScalar(phpString("APP_NAME")),
                    false),
                  phpActualParameter(
                    phpScalar(phpString("Glagol DSL project")),
                    false)
                ]),
              false)
          ])))]));
          
