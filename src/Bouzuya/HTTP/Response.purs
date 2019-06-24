module Bouzuya.HTTP.Response
  ( Response
  , response
  ) where

import Prelude

import Bouzuya.HTTP.Body (class ToBody, Body)
import Bouzuya.HTTP.Body as Body
import Bouzuya.HTTP.Headers (Headers)
import Bouzuya.HTTP.StatusCode (StatusCode)
import Data.Maybe (Maybe)
import Data.Traversable as Traversable
import Effect (Effect)

type Response =
  { body :: Maybe Body
  , headers :: Headers
  , status :: StatusCode
  }

response ::
  forall a. ToBody a => StatusCode -> Headers -> Maybe a -> Effect Response
response status headers bodyMaybe = do
  body <- Traversable.traverse Body.toBody bodyMaybe
  pure { body, headers, status }
