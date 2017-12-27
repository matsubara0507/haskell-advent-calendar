{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Adventar.Scraper where

import           AdventCalendar.Post              (Post, URL)
import           AdventCalendar.Utils             (Date, Html, strip, toDate)
import           Data.Default                     (def)
import           Data.Extensible                  hiding ((@=))
import           Data.Extensible.Instance.Default ()
import           Data.Text                        (Text, append)
import           Text.HTML.Scalpel.Core

calendarUrlsScraper :: Scraper Html [URL]
calendarUrlsScraper =
  chroots ("div" @: [hasClass "mod-calendarList"] // "ul" // "li") $ do
    url <- attr "href" $
      ("div" @: [hasClass "mod-calendarList-title"]) // "a"
    return $ append "http://adventar.org" url

postsScraper :: Scraper Html [Post]
postsScraper =
  chroots ("table" @: [hasClass "mod-entryList"] // "tr") entryScraper

entryScraper :: Scraper Text Post
entryScraper = hsequence
    $ #title    <@=> titleScraper
   <: #auther   <@=> autherScraper
   <: #url      <@=> urlScraper
   <: #date     <@=> dateScraper
   <: #calendar <@=> pure def
   <: nil

dateScraper :: Scraper Text Date
dateScraper = fmap toDate $ text ("th" @: [hasClass "mod-entryList-date"])

autherScraper :: Scraper Text Text
autherScraper = text $ "td" @: [hasClass "mod-entryList-user"] // "span"

titleScraper :: Scraper Text Text
titleScraper =
  fmap strip $ text ("div" @: [hasClass "mod-entryList-title", notHidden])

urlScraper :: Scraper Text URL
urlScraper =
  text $ "div" @: [hasClass "mod-entryList-url", notHidden]

notHidden :: AttributePredicate
notHidden = notP $ "hidden" @= ""
