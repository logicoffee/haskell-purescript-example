{-# LANGUAGE DataKinds #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}

module API where

import Control.Monad.IO.Class (liftIO)
import Crud
import DB
import qualified Data.ByteString.Lazy as BSL
import Data.Text
import Model.Language
import Network.HTTP.Media ((//), (/:))
import Servant
import Servant.API

type API = HealthcheckAPI :<|> LanguageAPI :<|> StaticAPI :<|> IndexAPI

server :: Server API
server = healthcheckAPI :<|> languageAPI :<|> staticAPI :<|> indexAPI

type HealthcheckAPI = "healthcheck" :> Get '[PlainText] Text

healthcheckAPI :: Server HealthcheckAPI
healthcheckAPI = return "I am healthy."

type LanguageAPI = "api" :> "languages" :> QueryParam "keyword" Text :> Get '[JSON] [Language]

languageAPI :: Server LanguageAPI
languageAPI keyword = do
  conn <- liftIO getConnection
  liftIO $ getLanguagesByKeyword conn keyword

type StaticAPI = "static" :> Raw

staticAPI :: Server StaticAPI
staticAPI = serveDirectoryWebApp "/workdir/public/static"

type IndexAPI = CaptureAll "segments" Text :> Get '[HTML] RawHTML

indexAPI :: Server IndexAPI
indexAPI _ = fmap RawHTML $ liftIO $ BSL.readFile "/workdir/public/index.html"

data HTML

newtype RawHTML = RawHTML {unRaw :: BSL.ByteString}

instance Accept HTML where
  contentType _ = "text" // "html" /: ("charset", "utf-8")

instance MimeRender HTML RawHTML where
  mimeRender _ = unRaw
