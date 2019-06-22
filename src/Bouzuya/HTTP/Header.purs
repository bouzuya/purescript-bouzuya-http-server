module Bouzuya.HTTP.Header
  ( Header
  , header
  , name
  , toTuple
  , value
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Maybe as Maybe
import Data.Tuple (Tuple)
import Data.Tuple as Tuple

type Header = Tuple String String

header :: String -> String -> Maybe Header
header n v = Maybe.Just (Tuple.Tuple n v)

name :: Header -> String
name = Tuple.fst

toTuple :: Header -> Tuple String String
toTuple = identity

value :: Header -> String
value = Tuple.snd
