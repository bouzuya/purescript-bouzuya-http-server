module Bouzuya.HTTP.Body
  ( Body
  , class FromBody
  , class ToBody
  , fromBody
  , toBody
  ) where

import Prelude

import Data.ArrayBuffer.Typed as TypedArray
import Data.ArrayBuffer.Types (ArrayView, Uint8, Uint8Array)
import Effect (Effect)
import Node.Buffer as Buffer
import Node.Encoding as Encoding

newtype Body = Body Uint8Array

class FromBody a where
  fromBody :: Body -> Effect a

class ToBody a where
  toBody :: a -> Effect Body

-- Uint8Array
instance fromBodyArrayViewUint8 :: FromBody (ArrayView Uint8) where
  fromBody (Body av) = pure av

-- Uint8Array
instance toBodyArrayViewUint8 :: ToBody (ArrayView Uint8) where
  toBody av = pure (Body av)

-- TODO: remove Node.Buffer
instance fromBodyString :: FromBody String where
  fromBody (Body av) = do
    b <- Buffer.fromArrayBuffer (TypedArray.buffer av)
    Buffer.toString Encoding.UTF8 b

instance toBodyString :: ToBody String where
  toBody s = do
    b <- Buffer.fromString s Encoding.UTF8
    ab <- Buffer.toArrayBuffer b
    map Body (TypedArray.whole ab)
