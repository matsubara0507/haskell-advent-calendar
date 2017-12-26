module AdventCalendar.Qiita.Fetch where

import           AdventCalendar.Post   (URL)
import           AdventCalendar.Utils  (Html)
import           Control.Lens          ((^.))
import           Data.String.Transform
import           Network.Wreq          (get, responseBody)

fetchHtml :: URL -> IO Html
fetchHtml url = do
  response <- get $ toString url
  return $ toTextStrict (response ^. responseBody)
