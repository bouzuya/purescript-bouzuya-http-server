{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "purescript-bouzuya-http-server"
, dependencies =
    [ "avar"
    , "bouzuya-http-method"
    , "bouzuya-http-status-code"
    , "node-http"
    , "psci-support"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
