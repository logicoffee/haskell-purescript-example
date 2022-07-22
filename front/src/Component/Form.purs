module Component.Form where

import Prelude
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Component.Util (class_)

type State
  = { keyword :: String }

data Action
  = Search
  | KeywordChanged String

type Output
  = String

type Slot
  = forall query. H.Slot query Output Unit

component :: forall query input m. MonadAff m => H.Component query input Output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  initialState _ = { keyword: "" }

  render :: State -> H.ComponentHTML Action () m
  render s =
    HH.div_
      [ HH.div [ class_ "mdc-text-field mdc-text-field--outlined" ]
          [ HH.input
              [ class_ "mdc-text-field__input"
              , HP.value s.keyword
              , HE.onValueChange KeywordChanged
              ]
          , HH.span [ class_ "mdc-notched-outline" ]
              [ HH.span [ class_ "mdc-notched-outline__leading" ] []
              , HH.span [ class_ "mdc-notched-outline__notch" ]
                  [ HH.span [ class_ "mdc-floating-label" ] [ HH.text "keyword" ]
                  ]
              , HH.span [ class_ "mdc-notched-outline__trailing" ] []
              ]
          ]
      , HH.button
          [ class_ "mdc-button mdc-button--raised", HE.onClick (const Search) ]
          [ HH.span [ class_ "mdc-button__ripple" ] []
          , HH.span [ class_ "mdc-button__focus-ring" ] []
          , HH.span [ class_ "mdc-button__label" ] [ HH.text "SEARCH" ]
          ]
      ]

  handleAction = case _ of
    Search -> do
      s <- H.get
      H.raise s.keyword
    KeywordChanged kw -> do
      H.modify_ _ { keyword = kw }
