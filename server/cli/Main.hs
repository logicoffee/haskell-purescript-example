{-# LANGUAGE OverloadedStrings #-}

module Main where

import Options.Applicative
import Turtle

data Cmd = Prepare

parser :: Parser Cmd
parser =
  subparser
    ( command "prepare" (info (pure Prepare) briefDesc)
    )

main :: IO ()
main = execParser parserInfo >>= doCmd
  where
    parserInfo = info (parser <**> helper) (progDesc "")

doCmd :: Cmd -> IO ()
doCmd cmd = case cmd of
  Prepare -> do
    shells "sqlite3 db/db.sqlite3 < db/schema.sql" empty
    shells "sqlite3 db/db.sqlite3 '.import data/languages.csv languages'" empty
