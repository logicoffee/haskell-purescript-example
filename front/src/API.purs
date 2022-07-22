module API where

import Prelude
import Data.Either (Either(..))
import Data.Argonaut.Decode (decodeJson)
import Effect.Aff (Aff)
import Affjax.Web as AX
import Affjax.ResponseFormat (json)
import Model (Language)

getLanguages :: String -> Aff (Array Language)
getLanguages keyword = do
  let
    url = "/api/languages?keyword=" <> keyword
  eRes <- AX.get json url
  case eRes of
    Left _ -> pure []
    Right res -> case decodeJson res.body of
      Left _ -> pure []
      Right ss -> pure ss
