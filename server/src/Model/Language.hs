{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

module Model.Language where

import Control.Monad (forM_)
import Data.Aeson
import Data.Int
import Data.Text (Text)
import Database.Beam

newtype LanguageT f = Language
  { _name :: Columnar f Text
  }
  deriving (Generic)

type Language = LanguageT Identity

type LanguageId = PrimaryKey LanguageT Identity

instance Beamable LanguageT

instance Table LanguageT where
  data PrimaryKey LanguageT f = LanguageId deriving (Generic, Beamable)
  primaryKey _ = LanguageId

instance ToJSON Language where
  toJSON lan =
    object
      [ "name" .= _name lan
      ]
