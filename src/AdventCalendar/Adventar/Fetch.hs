module AdventCalendar.Adventar.Fetch where

import           AdventCalendar.Post     (URL)
import           AdventCalendar.Utils    (Html)
import           Control.Lens            ((^.))
import           Data.String.Transform
import           Data.Text               (unpack)
import           Network.Wreq            (get, responseBody)
import           Test.WebDriver
import           Test.WebDriver.Commands (closeSession, getSource, openPage)

fetchHtml :: URL -> IO Html
fetchHtml url = do
  response <- get $ toString url
  return $ toTextStrict (response ^. responseBody)

fetchHtmlWith :: WDConfig -> URL -> IO Html
fetchHtmlWith config url = runSession config $ do
  openPage (unpack url)
  html <- getSource
  closeSession
  return html
