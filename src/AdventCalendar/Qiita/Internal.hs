{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita.Internal where

import           AdventCalendar.Post          (Post, URL)
import           AdventCalendar.Qiita.Fetch
import           AdventCalendar.Qiita.Scraper
import           AdventCalendar.Utils         (headerTitleScraper, scrapeHtml)
import           Control.Lens                 (set)
import           Data.Extensible
import           Data.Maybe                   (fromMaybe)
import           Data.Text                    (pack)
import           Shelly                       (shelly, sleep)

getPosts' :: URL -> IO [Post]
getPosts' url = do
  html <- fetchHtml url
  let
    posts = fromMaybe [] $ scrapeHtml postsScraper html
    calendar
        = #title @= fromMaybe "" (scrapeHtml headerTitleScraper html)
       <: #url   @= url
       <: emptyRecord
  shelly $ sleep 1
  return $ fmap (set #calendar calendar) posts

getUrls :: URL -> [Int] -> IO [URL]
getUrls _ [] = pure []
getUrls url (n:ns) = do
  result <- go n
  case result of
    [] -> pure result
    _  -> mappend result <$> getUrls url ns
  where
    go index = do
      html <- fetchHtml $ calendarsUrl url index
      shelly $ sleep 1
      return $ fromMaybe [] (scrapeHtml calendarUrlsScraper html)

calendarsUrl :: URL -> Int -> URL
calendarsUrl url index = mconcat [url, "?page=", pack $ show index]
