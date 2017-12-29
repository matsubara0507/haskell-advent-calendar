{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Adventar where

import           AdventCalendar.Adventar.Internal
import           AdventCalendar.Post              (ToPosts (..), URL)
import           Conduit
import           Data.Text                        (Text)
import           Test.WebDriver                   (WDConfig)

data Adventar = Adventar URL WDConfig

instance ToPosts Adventar where
  getPosts (Adventar url conf) = do
    urls <- lift $ getUrls url
    yieldMany urls =$= concatMapMC (getPosts' conf)

adventar :: Text -> WDConfig -> Adventar
adventar year =
  Adventar $ "https://adventar.org/calendars?year=" `mappend` year
