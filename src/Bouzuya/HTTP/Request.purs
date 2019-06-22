module Bouzuya.HTTP.Request
  ( Request
  , readBody
  ) where

import Bouzuya.HTTP.Body (class Body)
import Bouzuya.HTTP.Body as Body
import Bouzuya.HTTP.Headers (Headers)
import Bouzuya.HTTP.Method (Method)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Tuple (Tuple)
import Effect (Effect)

type Request =
  { body :: Uint8Array
  , headers :: Headers
  , method :: Method
  , pathname :: String
  , searchParams :: Array (Tuple String String)
  }

readBody :: forall a. Body a => Request -> Effect a
readBody { body } = Body.fromArray body
