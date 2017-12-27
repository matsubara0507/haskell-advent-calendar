{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita where

import           AdventCalendar.Post           (ToPosts (..), URL)
import           AdventCalendar.Qiita.Internal
import           Data.Text                     (Text)

newtype Qiita = Qiita URL

instance ToPosts Qiita where
  getPosts (Qiita url) = do
    urls <- getUrls url [1..1]
    mconcat <$> mapM getPosts' urls

qiita :: Text -> Qiita
qiita year =
  Qiita $ mconcat ["https://qiita.com/advent-calendar/", year, "/calendars"]
