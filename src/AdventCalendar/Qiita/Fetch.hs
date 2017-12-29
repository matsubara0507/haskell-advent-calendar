{-# LANGUAGE OverloadedStrings #-}

module AdventCalendar.Qiita.Fetch where

import           AdventCalendar.Post   (URL)
import           AdventCalendar.Utils  (Html)
import           Control.Exception     (catch)
import           Control.Lens          ((^.))
import           Data.Maybe            (fromMaybe)
import           Data.Text             (unpack)
import           Data.Text.Conversions
import           Network.HTTP.Client   (HttpException)
import           Network.Wreq          (get, responseBody)

fetchHtml :: URL -> IO Html
fetchHtml url = do
  response <- get $ unpack url
  return $ fromMaybe "" (decodeConvertText . UTF8 $ response ^. responseBody)

fetchHtml' :: URL -> IO Html
fetchHtml' url = fetchHtml url `catch` handler

handler :: HttpException -> IO Html
handler e = do
  putStrLn $ show e
  return ""
