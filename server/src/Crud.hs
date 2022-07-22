{-# LANGUAGE OverloadedStrings #-}

module Crud where

import DB
import Data.Text (Text)
import Database.Beam
import Database.Beam.Sqlite
import Database.SQLite.Simple
import Model.Language

getLanguagesByKeyword :: Connection -> Maybe Text -> IO [Language]
getLanguagesByKeyword conn mKeyword = runBeamSqliteDebug putStrLn conn $ do
  runSelectReturningList $
    select $ do
      language <- all_ (_languages db)
      case mKeyword of
        Just keyword -> guard_ $ _name language `like_` val_ ("%" <> keyword <> "%")
        Nothing -> pure ()
      return language
