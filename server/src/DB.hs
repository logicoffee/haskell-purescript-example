{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

module DB where

import Database.Beam
import Database.SQLite.Simple
import Model.Language

newtype DB f = DB
  { _languages :: f (TableEntity LanguageT)
  }
  deriving (Generic, Database be)

db :: DatabaseSettings be DB
db =
  defaultDbSettings
    `withDbModification` dbModification
      { _languages = setEntityName "languages"
      }

getConnection :: IO Connection
getConnection = open "db/db.sqlite3"
