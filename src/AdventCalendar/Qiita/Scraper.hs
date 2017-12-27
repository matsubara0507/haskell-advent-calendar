{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita.Scraper where

import           AdventCalendar.Post              (Post, URL)
import           AdventCalendar.Utils             (Date, Html, strip, toDate)
import           Data.Default                     (def)
import           Data.Extensible
import           Data.Extensible.Instance.Default ()
import           Data.Text                        (Text, append)
import           Text.HTML.Scalpel.Core

calendarUrlsScraper :: Scraper Html [URL]
calendarUrlsScraper =
  chroots ("table" @: [hasClass "adventCalendarList"] // "tbody" // "tr") $ do
    url <- attr "href" $
      ("td" @: [hasClass "adventCalendarList_calendarTitle"]) // "a"
    return $ append "http://qiita.com" url

postsScraper :: Scraper Html [Post]
postsScraper =
  chroots ("div" @: [hasClass "adventCalendarItem"]) itemScraper

itemScraper :: Scraper Html Post
itemScraper = hsequence
    $ #title    <@=> titleScraper
   <: #auther   <@=> autherScraper
   <: #url      <@=> urlScraper
   <: #date     <@=> dateScraper
   <: #calendar <@=> pure def
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
