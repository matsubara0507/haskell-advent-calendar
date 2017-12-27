{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module Options where

import           Data.Extensible
import           Data.Monoid         ((<>))
import           Data.Text           (Text, pack)
import           Options.Applicative

type Options = Record
   '[ "year" >: Text
    , "qiita" >: Bool
    , "adventar" >: Bool
    , "wdHost" >: Text
    , "wdPort" >: Int
    ]

optsParser :: Parser Options
optsParser = hsequence
    $ #year     <@=> yearParser
   <: #qiita    <@=> qiitaFlagParser
   <: #adventar <@=> adventarFlagParser
   <: #wdHost   <@=> wdHostParser
   <: #wdPort   <@=> wdPortParser
   <: nil

yearParser :: Parser Text
yearParser =
  textArgument (metavar "year" <> help "Year of Advent Calendar")

qiitaFlagParser :: Parser Bool
qiitaFlagParser =
  switch (long "qiita" <> help "get posts on Qiita Advent Calendar")

adventarFlagParser :: Parser Bool
adventarFlagParser =
  switch (long "adventar" <> help "get posts on ADVENTAR Advent Calendar")

wdHostParser :: Parser Text
wdHostParser =
  strOption (long "host" <> value "localhost" <> help "Host of Web driver")

wdPortParser :: Parser Int
wdPortParser =
  option auto (long "port" <> value 4444 <> help "Port of Web driver")

textArgument :: Mod ArgumentFields Text -> Parser Text
textArgument = argument (eitherReader $ Right . pack)

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts = info (helper <*> opts) . progDesc
