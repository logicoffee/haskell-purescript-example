module Component.Util where

import Prelude
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

class_ :: forall r t. String -> HH.IProp ( "class" :: String | r ) t
class_ = HP.class_ <<< HH.ClassName
