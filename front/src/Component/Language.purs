module Component.Language where

import Prelude
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Model (Language)
import Component.Util (class_)

type Input
  = Language

type State
  = Language

data Action
  = Receive Language

type Slot
  = forall query output. H.Slot query output Int

component :: forall query output m. MonadAff m => H.Component query Input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , receive = Just <<< Receive
              }
    }
  where
  initialState l = l

  render :: State -> H.ComponentHTML Action () m
  render l =
    HH.div
      [ class_ "mdc-card mdc-card--outlined" ]
      [ HH.div [ class_ "mdc-typography--headline6" ] [ HH.text l.name ] ]

  handleAction = case _ of
    Receive l -> do
      H.put l
