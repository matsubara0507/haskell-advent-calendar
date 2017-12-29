{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Adventar.Fetch where

import           AdventCalendar.Post     (URL)
import           AdventCalendar.Utils    (Html)
import           Control.Lens            ((^.))
import           Data.Maybe              (fromMaybe)
import           Data.Text               (unpack)
import           Data.Text.Conversions
import           Network.Wreq            (get, responseBody)
import           Test.WebDriver
import           Test.WebDriver.Commands (closeSession, getSource, openPage)

fetchHtml :: URL -> IO Html
fetchHtml url = do
  response <- get $ unpack url
  return $ fromMaybe "" (decodeConvertText . UTF8 $ response ^. responseBody)

fetchHtmlWith :: WDConfig -> URL -> IO Html
fetchHtmlWith config url = runSession config $ do
  openPage (unpack url)
  html <- getSource
  closeSession
  return html
