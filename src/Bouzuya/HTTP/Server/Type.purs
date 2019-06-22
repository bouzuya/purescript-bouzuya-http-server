module Bouzuya.HTTP.Server.Type
  ( Address
  , ServerOptions
  ) where

type Address =
  { host :: String
  , port :: Int
  }

type ServerOptions =
  { hostname :: String
  , port :: Int
  }
