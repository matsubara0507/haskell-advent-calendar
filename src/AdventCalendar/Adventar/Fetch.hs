module AdventCalendar.Adventar.Fetch where

import           AdventCalendar.Post     (URL)
import           AdventCalendar.Utils    (Html)
import           Data.Text               (unpack)
import           Test.WebDriver
import           Test.WebDriver.Commands (getSource, openPage)

fetchHtml :: WDConfig -> URL -> IO Html
fetchHtml config url = runSession config $ do
  openPage (unpack url)
  getSource
