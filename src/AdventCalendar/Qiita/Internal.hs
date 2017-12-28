{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita.Internal where

import           AdventCalendar.Post          (Post, URL)
import           AdventCalendar.Qiita.Fetch
import           AdventCalendar.Qiita.Scraper
import           AdventCalendar.Utils         (headerTitleScraper, scrapeHtml)
import           Control.Lens                 (set, (&), (.~), (^.))
import           Data.Extensible
import           Data.Maybe                   (fromMaybe)
import           Data.Text                    (pack)
import qualified Data.Text.IO                 as TIO
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
  TIO.putStrLn $ "get posts on " `mappend` url
  shelly $ sleep 1
  mapM updatePostTitle' $ set #calendar calendar <$> posts

updatePostTitle :: Post -> IO Post
updatePostTitle post = do
  html <- fetchHtml' $ post ^. #url
  let
    title = fromMaybe (post ^. #title) $ scrapeHtml headerTitleScraper html
  return $ post & #title .~ title

updatePostTitle' :: Post -> IO Post
updatePostTitle' post = shelly (sleep 1) >> updatePostTitle post

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
      putStrLn $ "get urls on page " `mappend` show index
      shelly $ sleep 1
      return $ fromMaybe [] (scrapeHtml calendarUrlsScraper html)

calendarsUrl :: URL -> Int -> URL
calendarsUrl url index = mconcat [url, "?page=", pack $ show index]
