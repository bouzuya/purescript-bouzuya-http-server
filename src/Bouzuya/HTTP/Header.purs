module Bouzuya.HTTP.Header
  ( Header
  , Headers
  ) where

import Data.Tuple (Tuple)

type Header = Tuple String String
type Headers = Array Header
