{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE TypeOperators #-}

module AdventCalendar.Post where

import           AdventCalendar.Utils           (Date)
import           Data.Extensible
import           Data.Extensible.Instance.Aeson ()
import           Data.Proxy                     (Proxy)
import           Data.Text                      (Text)

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
