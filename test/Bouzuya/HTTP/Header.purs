module Test.Bouzuya.HTTP.Header
  ( tests
  ) where

import Prelude

import Bouzuya.HTTP.Header as Header
import Data.Maybe as Maybe
import Data.String as String
import Data.Tuple as Tuple
import Test.Unit (TestSuite)
import Test.Unit as TestUnit
import Test.Unit.Assert as Assert

tests :: TestSuite
tests = TestUnit.suite "Bouzuya.HTTP.Header" do
  TestUnit.test "header" do
    -- TODO: escape
    let
      n = "Content-Type"
      v = "text/html"
      h1 = Header.header n v
    Assert.equal (Maybe.Just (Tuple.Tuple n v)) (map Header.toTuple h1)

  TestUnit.test "lookup" do
    let
      k = "Content-Type"
      v = "text/html"
      kv = Tuple.Tuple k v
      headers = [ kv ]
    Assert.equal (Maybe.Just kv) (Header.lookup k headers)
    Assert.equal (Maybe.Just kv) (Header.lookup (String.toUpper k) headers)

  TestUnit.test "name" do
    let
      n = "Content-Type"
      v = "text/html"
      h1 = Header.header n v
    Assert.equal (Maybe.Just n) (map Header.name h1)

  TestUnit.test "toTuple" do
    let
      n = "Content-Type"
      v = "text/html"
      h1 = Header.header n v
    Assert.equal (Maybe.Just (Tuple.Tuple n v)) (map Header.toTuple h1)

  TestUnit.test "value" do
    let
      n = "Content-Type"
      v = "text/html"
      h1 = Header.header n v
    Assert.equal (Maybe.Just v) (map Header.value h1)
