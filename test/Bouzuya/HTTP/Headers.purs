module Test.Bouzuya.HTTP.Headers
  ( tests
  ) where

import Prelude

import Bouzuya.HTTP.Header as Header
import Bouzuya.HTTP.Headers as Headers
import Data.Array as Array
import Data.Maybe as Maybe
import Data.String as String
import Test.Unit (TestSuite)
import Test.Unit as TestUnit
import Test.Unit.Assert as Assert

tests :: TestSuite
tests = TestUnit.suite "Bouzuya.HTTP.Headers" do
  TestUnit.test "lookup" do
    let
      n = "Content-Type"
      v = "text/html"
      h1 = Header.header n v
      headers = Array.mapMaybe identity [h1]
    Assert.assert "h1" (Maybe.isJust h1)
    Assert.equal h1 (Headers.lookup n headers)
    Assert.equal h1 (Headers.lookup (String.toUpper n) headers)
