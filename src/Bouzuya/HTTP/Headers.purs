module Bouzuya.HTTP.Headers
  ( Headers
  , lookup
  ) where

import Prelude

import Bouzuya.HTTP.Header (Header)
import Data.Array as Array
import Data.Maybe (Maybe)
import Data.String as String
import Data.Tuple as Tuple

type Headers = Array Header

lookup :: String -> Headers -> Maybe Header
lookup key =
  let eqKey = eq (String.toLower key)
  in Array.find (eqKey <<< String.toLower <<< Tuple.fst)
