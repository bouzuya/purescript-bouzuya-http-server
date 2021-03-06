module Bouzuya.HTTP.Server.Node
  ( run
  ) where

import Prelude

import Bouzuya.HTTP.Body (Body)
import Bouzuya.HTTP.Body as Body
import Bouzuya.HTTP.Header (Header)
import Bouzuya.HTTP.Header as Header
import Bouzuya.HTTP.Headers (Headers)
import Bouzuya.HTTP.Method as Method
import Bouzuya.HTTP.Request (Request)
import Bouzuya.HTTP.Response (Response)
import Bouzuya.HTTP.Server.Type (ServerOptions, Address)
import Bouzuya.HTTP.StatusCode (StatusCode(..))
import Data.Array as Array
import Data.ArrayBuffer.Typed as TypedArray
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Either as Either
import Data.Foldable as Foldable
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Maybe as Maybe
import Data.Nullable as Nullable
import Data.String (Pattern(..))
import Data.String as String
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as Aff
import Effect.Aff.AVar as AVar
import Effect.Class (liftEffect)
import Foreign.Object as Object
import Global.Unsafe (unsafeDecodeURIComponent)
import Node.Buffer as Buffer
import Node.HTTP (Server)
import Node.HTTP as HTTP
import Node.Net.Server as Net
import Node.Net.Socket (Socket)
import Node.Net.Socket as Socket
import Node.Stream as Stream
import Node.URL as URL
import Partial.Unsafe as Partial
import Unsafe.Coerce as Unsafe

foreign import socket :: HTTP.Request -> Socket

setBody :: HTTP.Response -> Maybe Body -> Effect Unit
setBody response bodyMaybe = do
  let writable = HTTP.responseAsStream response
  case bodyMaybe of
    Maybe.Just body -> do
      av <- Body.fromBody body :: _ Uint8Array
      b <- Buffer.fromArrayBuffer (TypedArray.buffer av)
      _ <- Stream.write writable b (pure unit)
      pure unit
    Maybe.Nothing -> pure unit
  Stream.end writable (pure unit)

setHeader :: HTTP.Response -> Header -> Effect Unit
setHeader response header =
  let
    n = Header.name header
    v = Header.value header
  in
    HTTP.setHeader response n v

setHeaders :: HTTP.Response -> Headers -> Effect Unit
setHeaders response headers =
  Foldable.for_ headers (setHeader response)

setStatusCode :: HTTP.Response -> StatusCode -> Effect Unit
setStatusCode response (StatusCode code message) = do
  _ <- HTTP.setStatusCode response code
  HTTP.setStatusMessage response message

readBody :: HTTP.Request -> Aff (Maybe Body)
readBody request = do
  let readable = HTTP.requestAsStream request
  bv <- AVar.empty
  bsv <- AVar.new []
  -- TODO: check exception
  _ <- liftEffect $ Stream.onData readable \b -> Aff.launchAff_ do
    bs <- AVar.take bsv
    AVar.put (bs <> [b]) bsv
  _ <- liftEffect $ Stream.onError readable \e -> Aff.launchAff_ do
    AVar.kill e bv
  _ <- liftEffect $ Stream.onEnd readable $ Aff.launchAff_ do
    bs <- AVar.take bsv
    if Array.null bs
      then AVar.put Maybe.Nothing bv
      else do
        b <- liftEffect (Buffer.concat bs)
        ab <- liftEffect (Buffer.toArrayBuffer b)
        av <- (liftEffect (TypedArray.whole ab)) :: _ Uint8Array
        body <- liftEffect (Body.toBody av)
        AVar.put (Maybe.Just body) bv
  AVar.take bv

readRemoteAddress :: HTTP.Request -> Effect Address
readRemoteAddress request = do
  let socket' = socket request
  hostMaybe <- Socket.remoteAddress socket'
  host <-
    Maybe.maybe'
      (\_ -> Partial.unsafeCrashWith "socket is not connected")
      pure
      hostMaybe
  portMaybe <- Socket.remotePort socket'
  port <-
    Maybe.maybe'
      (\_ -> Partial.unsafeCrashWith "socket is not connected")
      pure
      portMaybe
  pure { host, port }

readRequest :: HTTP.Request -> Aff Request
readRequest request = do
  let
    headers = HTTP.requestHeaders request
    -- TODO: 405 Method Not Allowed ?
    method = fromMaybe Method.GET $
      Method.fromString $ HTTP.requestMethod request
    url = HTTP.requestURL request
    urlObject = URL.parse url
    pathname = fromMaybe "" (Nullable.toMaybe urlObject.pathname)
    searchParams = maybe [] parseQueryString (Nullable.toMaybe urlObject.query)
    parseQueryString :: String -> Array (Tuple String String)
    parseQueryString =
      String.split (Pattern "&")
        >>> map (String.split (Pattern "="))
        >>> map (map unsafeDecodeURIComponent)
        >>> map
          (
            case _ of
              [k, v] -> Just (Tuple k v)
              _ -> Nothing
          )
        >>> Array.catMaybes
  body <- readBody request
  remoteAddress <- liftEffect (readRemoteAddress request)
  pure $
    { body
    , headers: Object.foldMap (\k v -> [Tuple k v]) headers
    , method
    , pathname
    , remoteAddress
    , searchParams
    }

writeResponse
  :: HTTP.Response
  -> Response
  -> Effect Unit
writeResponse response { body, headers, status } = do
  _ <- setStatusCode response status
  _ <- setHeaders response headers
  _ <- setBody response body
  pure unit

handleRequest
  :: (Request -> Aff Response)
  -> HTTP.Request
  -> HTTP.Response
  -> Effect Unit
handleRequest onRequest request response = Aff.launchAff_ do
  req <- readRequest request
  res <- onRequest req
  liftEffect $ writeResponse response res

address :: Server -> Effect Address
address server = do
  let
    server' :: Net.Server
    server' = Unsafe.unsafeCoerce server
  addressMaybe <- Net.address server'
  addressEither <-
    Maybe.maybe'
      (\_ -> Partial.unsafeCrashWith "server is not running")
      pure
      addressMaybe
  { address: address', port } <-
    Either.either
      pure
      (\_ -> Partial.unsafeCrashWith "server is not TCP server")
      addressEither
  pure { host: address', port }

run
  :: ServerOptions
  -> (Address -> Effect Unit)
  -> (Request -> Aff Response)
  -> Effect Unit
run { host, port } onListen onRequest = do
  server <- HTTP.createServer (handleRequest onRequest)
  let
    listenOptions =
      { hostname: host
      , port
      , backlog: Nothing
      }
  HTTP.listen
    server
    listenOptions
    do
      addr <- address server
      _ <- onListen addr
      pure unit
