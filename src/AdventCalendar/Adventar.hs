{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Adventar where

import           AdventCalendar.Adventar.Fetch
import           AdventCalendar.Adventar.Scraper
import           AdventCalendar.Post             (Post, ToPosts (..), URL)
import           AdventCalendar.Utils            (headerTitleScraper,
                                                  scrapeHtml)
import           Control.Lens                    (set)
import           Data.Extensible
import           Data.Maybe                      (fromMaybe)
import           Shelly                          (shelly, sleep)
import           Test.WebDriver                  (WDConfig)

data Adventar = Adventar { getUrl :: URL, getConfig :: WDConfig }

instance ToPosts Adventar where
  getPosts (Adventar url conf) = getPosts' conf url

getPosts' :: WDConfig -> URL -> IO [Post]
getPosts' conf url = do
  html <- fetchHtml conf url
  let
    posts = fromMaybe [] $ scrapeHtml postsScraper html
    calendar
        = #title @= fromMaybe "" (scrapeHtml headerTitleScraper html)
       <: #url   @= url
       <: emptyRecord
  shelly $ sleep 1
  return $ fmap (set #calendar calendar) posts
