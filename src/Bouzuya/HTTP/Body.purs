module Bouzuya.HTTP.Body
  ( class Body
  , fromArray
  , toArray
  ) where

import Prelude

import Data.ArrayBuffer.Typed as TypedArray
import Data.ArrayBuffer.Types (ArrayView, Uint8, Uint8Array)
import Effect (Effect)
import Node.Buffer as Buffer
import Node.Encoding as Encoding

class Body a where
  fromArray :: Uint8Array -> Effect a
  toArray :: a -> Effect (Uint8Array)

-- Uint8Array
instance bodyArrayViewUint8 :: Body (ArrayView Uint8) where
  fromArray = pure
  toArray = pure

-- TODO: remove Node.Buffer
instance bodyString :: Body String where
  fromArray av = do
    b <- Buffer.fromArrayBuffer (TypedArray.buffer av)
    Buffer.toString Encoding.UTF8 b

  toArray s = do
    b <- Buffer.fromString s Encoding.UTF8
    ab <- Buffer.toArrayBuffer b
    TypedArray.whole ab
