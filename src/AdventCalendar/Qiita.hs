{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita
  ( Qiita(..)
  ) where

import           AdventCalendar.Post           (ToPosts (..), URL)
import           AdventCalendar.Qiita.Internal

newtype Qiita = Qiita URL

instance ToPosts Qiita where
  getPosts (Qiita url) = do
    urls <- getUrls url [1..1]
    mconcat <$> mapM getPosts' urls
