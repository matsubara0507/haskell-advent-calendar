{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Utils where

import           Data.Aeson               (ToJSON)
import           Data.Aeson.Encode.Pretty (encodePrettyToTextBuilder)
import           Data.Maybe               (fromMaybe)
import           Data.Text                (Text)
import qualified Data.Text                as T
import           Data.Text.Lazy.Builder   (toLazyText)
import           Data.Text.Lazy.Encoding  (encodeUtf8)
import qualified Data.Text.Lazy.IO        as LT
import           Text.HTML.Scalpel.Core   (Scraper, scrapeStringLike)

type Html = Text

scrapeHtml :: Scraper Html a -> Html -> Maybe a
scrapeHtml = flip scrapeStringLike

writeJson :: ToJSON a => Text -> a -> IO ()
writeJson jsonPath =
  LT.writeFile (T.unpack jsonPath) . toLazyText . encodePrettyToTextBuilder

type Date = Text

toDate :: Text -> Date
toDate = T.intercalate "/" . fmap (twoDigit . T.strip) . T.splitOn "/"

twoDigit :: Text -> Text
twoDigit = T.takeEnd 2 . T.append "0"

strip :: Text -> Text
strip = T.strip
