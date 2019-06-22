{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "purescript-bouzuya-http-server"
, dependencies =
    [ "arraybuffer"
    , "avar"
    , "bouzuya-http-method"
    , "bouzuya-http-status-code"
    , "node-http"
    , "node-net"
    , "psci-support"
    , "test-unit"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
