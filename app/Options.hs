{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module Options where

import           Data.Extensible
import           Data.Monoid         ((<>))
import           Data.Text           (Text, pack)
import           Options.Applicative

data Cmd
  = Fetch FetchOptions
  | Markdown MarkdownOptions

type MarkdownOptions = Record
   '[ "inputs" >: [Text]
    , "output" >: Maybe Text
    , "noCategory" >: Bool
    ]

type FetchOptions = Record
   '[ "year" >: Text
    , "qiita" >: Bool
    , "adventar" >: Bool
    , "wdHost" >: Text
    , "wdPort" >: Int
    , "output" >: Text
    ]

cmdParser :: Parser Cmd
cmdParser = subparser $
     command "fetch"
       (Fetch <$> fetchOptsParser `withInfo` "fetch posts on advent calendar to json file.")
  <> command "markdown"
       (Markdown <$> mdOptsParser `withInfo` "convert markdown from posts json file.")
  <> metavar "( fetch | markdown )"
  <> help "choice subcommand"

fetchOptsParser :: Parser FetchOptions
fetchOptsParser = hsequence
    $ #year     <@=> yearParser
   <: #qiita    <@=> qiitaFlagParser
   <: #adventar <@=> adventarFlagParser
   <: #wdHost   <@=> wdHostParser
   <: #wdPort   <@=> wdPortParser
   <: #output   <@=> outputParser
   <: nil

mdOptsParser :: Parser MarkdownOptions
mdOptsParser = hsequence
    $ #inputs     <@=> inputsParser
   <: #output     <@=> outputParser'
   <: #noCategory <@=> noCategoryParser
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

outputParser :: Parser Text
outputParser =
  textArgument (metavar "output" <> help "Output json file path")

inputsParser :: Parser [Text]
inputsParser = some $
  textArgument (metavar "inputs" <> help "Input json file paths")

outputParser' :: Parser (Maybe Text)
outputParser' = option (eitherReader $ Right . Just . pack) $
  long "output" <> short 'o' <> value Nothing <> help "Output json file path"

noCategoryParser :: Parser Bool
noCategoryParser =
  switch (long "no-category" <> help "can't categorize posts")

textArgument :: Mod ArgumentFields Text -> Parser Text
textArgument = argument (eitherReader $ Right . pack)

withInfo :: Parser a -> String -> ParserInfo a
withInfo opts = info (helper <*> opts) . progDesc
