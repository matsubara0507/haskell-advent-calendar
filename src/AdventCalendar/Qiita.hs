{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita where

import           AdventCalendar.Post           (ToPosts (..), URL)
import           AdventCalendar.Qiita.Internal
import           Conduit
import           Data.Text                     (Text)

newtype Qiita = Qiita URL

instance ToPosts Qiita where
  getPosts (Qiita url) = do
    urls <- lift $ getUrls url [1..1]
    yieldMany urls =$= concatMapMC getPosts'

qiita :: Text -> Qiita
qiita year =
  Qiita $ mconcat ["https://qiita.com/advent-calendar/", year, "/calendars"]
