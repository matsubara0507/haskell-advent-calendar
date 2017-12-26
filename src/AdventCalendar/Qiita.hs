{-# LANGUAGE OverloadedLabels #-}

module AdventCalendar.Qiita where

import           AdventCalendar.Post          (Post, ToPosts (..), URL)
import           AdventCalendar.Qiita.Fetch
import           AdventCalendar.Qiita.Scraper
import           AdventCalendar.Utils         (scrapeHtml)
import           Control.Lens                 (set)
import           Data.Maybe                   (fromMaybe)

newtype Qiita = Qiita { getUrl :: URL }

instance ToPosts Qiita where
  getPosts (Qiita url) = do
    html <- fetchHtml url
    let
      posts = fromMaybe [] $ scrapeHtml scraper html
    return $ fmap (set #calendar url) posts
