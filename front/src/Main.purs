module Main where

import Prelude
import Data.Array (mapWithIndex)
import Data.Maybe (Maybe(..))
import Type.Proxy (Proxy(..))
import Effect (Effect)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)
import Component.Language as L
import Component.Form as F
import Model (Language)
import API (getLanguages)
import Component.Util (class_)

main :: Effect Unit
main =
  HA.runHalogenAff do
    body <- HA.awaitBody
    runUI component unit body

type State
  = { languages :: Array Language }

data Action
  = Initialize
  | Search String

type Slots
  = ( languages :: L.Slot
    , form :: F.Slot
    )

component :: forall query input output m. MonadAff m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just Initialize
              }
    }
  where
  initialState _ = { languages: [] }

  render :: State -> H.ComponentHTML Action Slots m
  render state =
    HH.div [ class_ "layout" ]
      [ HH.slot _form unit F.component unit Search
      , HH.div [ class_ "layout-inner" ]
          $ flip mapWithIndex state.languages
          $ \idx languages -> HH.slot_ _languages idx L.component languages
      ]

  handleAction = case _ of
    Initialize -> do
      languages <- H.liftAff $ getLanguages ""
      H.modify_ _ { languages = languages }
    Search kw -> do
      languages <- H.liftAff $ getLanguages kw
      H.modify_ _ { languages = languages }

_languages = Proxy :: Proxy "languages"

_form = Proxy :: Proxy "form"
