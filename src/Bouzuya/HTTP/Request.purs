module Bouzuya.HTTP.Request
  ( Request
  ) where

import Bouzuya.HTTP.Headers (Headers)
import Bouzuya.HTTP.Method (Method)
import Data.Tuple (Tuple)

type Request =
  { body :: String
  , headers :: Headers
  , method :: Method
  , pathname :: String
  , searchParams :: Array (Tuple String String)
  }
