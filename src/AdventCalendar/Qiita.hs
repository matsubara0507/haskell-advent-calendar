{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita where

import           AdventCalendar.Post          (Post, ToPosts (..), URL)
import           AdventCalendar.Qiita.Fetch
import           AdventCalendar.Qiita.Scraper
import           AdventCalendar.Utils         (headerTitleScraper, scrapeHtml)
import           Control.Lens                 (set)
import           Data.Extensible
import           Data.Maybe                   (fromMaybe)

newtype Qiita = Qiita { getUrl :: URL }

instance ToPosts Qiita where
  getPosts (Qiita url) = do
    html <- fetchHtml url
    let
      posts = fromMaybe [] $ scrapeHtml postsScraper html
      calendar
          = #title @= fromMaybe "" (scrapeHtml headerTitleScraper html)
         <: #url   @= url
         <: emptyRecord
    return $ fmap (set #calendar calendar) posts
