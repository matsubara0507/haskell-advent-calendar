{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Adventar
  ( Adventar (..)
  ) where

import           AdventCalendar.Adventar.Internal
import           AdventCalendar.Post              (ToPosts (..), URL)
import           Test.WebDriver                   (WDConfig)

data Adventar = Adventar { getUrl :: URL, getConfig :: WDConfig }

instance ToPosts Adventar where
  getPosts (Adventar url conf) = do
    urls <- take 2 <$> getUrls url
    mconcat <$> mapM (getPosts' conf) urls
