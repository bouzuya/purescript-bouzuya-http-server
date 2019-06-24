module Bouzuya.HTTP.Request
  ( Request
  ) where

import Bouzuya.HTTP.Body (Body)
import Bouzuya.HTTP.Headers (Headers)
import Bouzuya.HTTP.Method (Method)
import Bouzuya.HTTP.Server.Type (Address)
import Data.Tuple (Tuple)

type Request =
  { body :: Body
  , headers :: Headers
  , method :: Method
  , pathname :: String
  , remoteAddress :: Address
  , searchParams :: Array (Tuple String String)
  }
