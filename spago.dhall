{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "purescript-bouzuya-http-server"
, dependencies =
    [ "aff"
    , "avar"
    , "bouzuya-http-method"
    , "bouzuya-http-status-code"
    , "effect"
    , "foreign-object"
    , "node-http"
    , "prelude"
    , "psci-support"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
