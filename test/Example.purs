module Test.Example
  ( tests
  ) where

import Prelude

import Bouzuya.HTTP.Response as Response
import Bouzuya.HTTP.Server as Server
import Bouzuya.HTTP.StatusCode as StatusCode
import Data.Maybe as Maybe
import Data.Tuple as Tuple
import Effect.Class as Class
import Effect.Class.Console as Console
import Test.Unit (TestSuite)
import Test.Unit as TestUnit

tests :: TestSuite
tests = TestUnit.suite "Example" do
  TestUnit.test "example" do
    let serverOptions = { host: "0.0.0.0", port: 3000 }
    Class.liftEffect
      (Server.run
        serverOptions
        (\address -> do
          Console.log "listen"
          -- { host: "0.0.0.0", port: 3000 }
          Console.logShow address)
        (\request -> do
          Console.log "request"
          Class.liftEffect
            (Response.response
              StatusCode.status200
              [ Tuple.Tuple "Content-Type" "text/plain" ]
              -- e.g. GET /foo
              (Maybe.Just ((show request.method) <> " " <> request.pathname)))))
    --
    -- $ curl -D - http://localhost:3000/foo
    -- HTTP/1.1 200 OK
    -- Content-Type: text/plain
    -- Date: Sat, 22 Jun 2019 09:45:46 GMT
    -- Connection: keep-alive
    -- Transfer-Encoding: chunked
    --
    -- GET /foo
