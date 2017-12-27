{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

module AdventCalendar.Post where

import           AdventCalendar.Utils           (Date)
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
    ]

type URL = Text

type Calendar = Record
   '[ "title" >: Text
    , "url" >: URL
    ]

class ToPosts a where
  getPosts :: a -> IO [Post]

isHaskellPost :: Post -> Bool
isHaskellPost post = any ("Haskell" `isInfixOf`)
  [ post ^. #title
  , post ^. #calendar ^. #title
  ]
