module Main where

import API
import Data.Proxy
import Network.Wai.Handler.Warp
import Network.Wai.Logger (withStdoutLogger)
import Servant.Server

main :: IO ()
main = do
  let app = serve api server
  withStdoutLogger $ \logger -> do
    let settings = setPort 8000 $ setLogger logger defaultSettings
    runSettings settings app
  where
    api :: Proxy API
    api = Proxy
