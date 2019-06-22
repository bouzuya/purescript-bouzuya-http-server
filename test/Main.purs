module Test.Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Test.Bouzuya.HTTP.Header as Header
import Test.Bouzuya.HTTP.Headers as Headers
import Test.Unit.Main as TestUnitMain

main :: Effect Unit
main = TestUnitMain.runTest do
  Header.tests
  Headers.tests
