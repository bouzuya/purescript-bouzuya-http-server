module Test.Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Test.Bouzuya.HTTP.Header as Header
import Test.Unit as TestUnit
import Test.Unit.Assert as Assert
import Test.Unit.Main as TestUnitMain

main :: Effect Unit
main = TestUnitMain.runTest do
  Header.tests
  TestUnit.suite "dummy" do
    TestUnit.test "dummy" do
      Assert.equal 1 1
