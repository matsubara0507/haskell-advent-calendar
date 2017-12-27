{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Adventar.Internal where

import           AdventCalendar.Adventar.Fetch
import           AdventCalendar.Adventar.Scraper
import           AdventCalendar.Post             (Post, URL)
import           AdventCalendar.Utils            (headerTitleScraper,
                                                  scrapeHtml)
import           Control.Lens                    (set)
import           Data.Extensible
import           Data.Maybe                      (fromMaybe)
import qualified Data.Text.IO                    as TIO
import           Shelly                          (shelly, sleep)
import           Test.WebDriver                  (WDConfig)

getPosts' :: WDConfig -> URL -> IO [Post]
getPosts' conf url = do
  html <- fetchHtmlWith conf url
  let
    posts = fromMaybe [] $ scrapeHtml postsScraper html
    calendar
        = #title @= fromMaybe "" (scrapeHtml headerTitleScraper html)
       <: #url   @= url
       <: emptyRecord
  TIO.putStrLn $ "get posts on " `mappend` url
  shelly $ sleep 1
  return $ fmap (set #calendar calendar) posts

getUrls :: URL -> IO [URL]
getUrls url = do
  html <- fetchHtml url
  return $ fromMaybe [] (scrapeHtml calendarUrlsScraper html)
