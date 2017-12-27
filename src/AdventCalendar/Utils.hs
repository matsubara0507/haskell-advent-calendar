{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Utils where

import           Data.Aeson               (FromJSON, ToJSON, decode)
import           Data.Aeson.Encode.Pretty (encodePrettyToTextBuilder)
import           Data.Maybe               (fromMaybe)
import           Data.Text                (Text, unpack)
import qualified Data.Text                as T
import           Data.Text.Lazy.Builder   (toLazyText)
import           Data.Text.Lazy.Encoding  (encodeUtf8)
import qualified Data.Text.Lazy.IO        as LT
import           Test.WebDriver           (WDConfig (..), chrome, defaultConfig,
                                           useBrowser)
import           Text.HTML.Scalpel.Core   (Scraper, scrapeStringLike, text,
                                           (//))

type Html = Text

scrapeHtml :: Scraper Html a -> Html -> Maybe a
scrapeHtml = flip scrapeStringLike

headerTitleScraper :: Scraper Html Text
headerTitleScraper = text $ "head" // "title"

writeJson :: ToJSON a => Text -> a -> IO ()
writeJson jsonPath =
  LT.writeFile (T.unpack jsonPath) . toLazyText . encodePrettyToTextBuilder

readJson :: FromJSON a => Text -> IO [a]
readJson jsonPath =
  fromMaybe [] . decode . encodeUtf8 <$> LT.readFile (unpack jsonPath)

type Date = Text

toDate :: Text -> Date
toDate = T.intercalate "/" . fmap (twoDigit . T.strip) . T.splitOn "/"

twoDigit :: Text -> Text
twoDigit = T.takeEnd 2 . T.append "0"

strip :: Text -> Text
strip = T.strip

mkDriver :: Text -> Text -> WDConfig
mkDriver host port = useBrowser chrome $
  defaultConfig { wdHost = T.unpack host, wdPort = read (T.unpack port) }
