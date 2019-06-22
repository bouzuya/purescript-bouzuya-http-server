module Bouzuya.HTTP.Response
  ( Response
  , response
  ) where

import Prelude

import Bouzuya.HTTP.Body (class Body)
import Bouzuya.HTTP.Body as Body
import Bouzuya.HTTP.Headers (Headers)
import Bouzuya.HTTP.StatusCode (StatusCode)
import Data.ArrayBuffer.Types (Uint8Array)
import Effect (Effect)

type Response =
  { body :: Uint8Array
  , headers :: Headers
  , status :: StatusCode
  }

response :: forall a. Body a => StatusCode -> Headers -> a -> Effect Response
response status headers body = do
  body' <- Body.toArray body
  pure { body: body', headers, status }
