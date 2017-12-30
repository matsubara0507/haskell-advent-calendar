{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE Rank2Types        #-}
{-# LANGUAGE TypeOperators     #-}

module AdventCalendar.Post where

import           AdventCalendar.Utils           (Date)
import           Conduit                        (Source)
import           Control.Lens                   ((^.))
import           Data.Extensible
import           Data.Extensible.Instance.Aeson ()
import           Data.Text                      (Text, isInfixOf)

type Post = Record
   '[ "title" >: Text
    , "auther" >: Text
    , "url" >: URL
    , "date" >: Date
    , "calendar" >: Calendar
    , "category" >: Text
    ]

type URL = Text

type Calendar = Record
   '[ "title" >: Text
    , "url" >: URL
    ]

class ToPosts a where
  getPosts :: a -> Source IO Post

isHaskellPost :: Post -> Bool
isHaskellPost post = any ("Haskell" `isInfixOf`)
  [ post ^. #title
  , post ^. #calendar ^. #title
  ]

toMarkdown :: Post -> [Text]
toMarkdown post = mconcat <$>
  [ [ "**[", post ^. #title, "](", post ^. #url, ")**  " ]
  , [ " by ", post ^. #auther
    , " on [", post ^. #calendar ^. #title, "](", post ^. #calendar ^. #url, ") "
    , post ^. #date
    ]
  ]
