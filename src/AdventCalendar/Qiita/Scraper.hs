{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita.Scraper where

import           AdventCalendar.Post    (Post, URL)
import           AdventCalendar.Utils   (Date, Html, strip, toDate)
import           Data.Extensible
import           Data.Text              (Text)
import           Text.HTML.Scalpel.Core

scraper :: Scraper Html [Post]
scraper = chroots ("div" @: [hasClass "adventCalendarItem"]) itemScraper

itemScraper :: Scraper Html Post
itemScraper = hsequence
    $ #title    <@=> titleScraper
   <: #auther   <@=> autherScraper
   <: #url      <@=> urlScraper
   <: #date     <@=> dateScraper
   <: #calendar <@=> pure ""
   <: nil

titleScraper :: Scraper Html Text
titleScraper =
  text $ itemS "div" "commentWrapper" // itemS "div" "entry"

autherScraper :: Scraper Html Text
autherScraper =
  fmap strip . text $ itemS "div" "calendarContent" // itemS "a" "author"

urlScraper :: Scraper Html URL
urlScraper =
  attr "href" $ itemS "div" "commentWrapper" // itemS "div" "entry" // "a"

dateScraper :: Scraper Html Date
dateScraper =
  fmap toDate . text $ itemS "div" "date"

itemS :: TagName -> String -> Selector
itemS tag str = tag @: [hasClass $ mappend "adventCalendarItem_" str ]
