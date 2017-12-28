{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita.Fetch where

import           AdventCalendar.Post   (URL)
import           AdventCalendar.Utils  (Html)
import           Control.Exception     (catch)
import           Control.Lens          ((^.))
import           Data.String.Transform
import           Network.HTTP.Client   (HttpException)
import           Network.Wreq          (get, responseBody)

fetchHtml :: URL -> IO Html
fetchHtml url = do
  response <- get $ toString url
  return $ toTextStrict (response ^. responseBody)

fetchHtml' :: URL -> IO Html
fetchHtml' url = fetchHtml url `catch` handler

handler :: HttpException -> IO Html
handler e = do
  putStrLn $ show e
  return ""
