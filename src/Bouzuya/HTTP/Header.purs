module Bouzuya.HTTP.Header
  ( Header
  , Headers
  , header
  , lookup
  , name
  , toTuple
  , value
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe)
import Data.Maybe as Maybe
import Data.String as String
import Data.Tuple (Tuple)
import Data.Tuple as Tuple

type Header = Tuple String String
type Headers = Array Header

header :: String -> String -> Maybe Header
header n v = Maybe.Just (Tuple.Tuple n v)

lookup :: String -> Headers -> Maybe Header
lookup key =
  let eqKey = eq (String.toLower key)
  in Array.find (eqKey <<< String.toLower <<< Tuple.fst)

name :: Header -> String
name = Tuple.fst

toTuple :: Header -> Tuple String String
toTuple = identity

value :: Header -> String
value = Tuple.snd
