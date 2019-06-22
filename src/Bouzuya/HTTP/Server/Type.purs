module Bouzuya.HTTP.Server.Type
  ( Address
  , ServerOptions
  ) where

type Address =
  { host :: String
  , port :: Int
  }

type ServerOptions =
  { host :: String
  , port :: Int
  }
