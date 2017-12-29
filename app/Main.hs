{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           AdventCalendar
import           Conduit
import           Control.Lens        ((&), (.~), (^.))
import           Data.List           (intercalate)
import           Data.Maybe          (fromMaybe)
import qualified Data.Text           as T
import qualified Data.Text.IO        as T
import           GHC.IO.Encoding
import           Options
import           Options.Applicative (execParser)

main :: IO ()
main = do
  setLocaleEncoding utf8
  cmd <- execParser $
    cmdParser `withInfo` "get Haskell posts on Advent Calendar"
  exec cmd

exec :: Cmd -> IO ()
exec (Fetch opts)    = fetchCmd opts
exec (Markdown opts) = mdCmd opts

fetchCmd :: FetchOptions -> IO ()
fetchCmd opts = do
  result1 <- pipe1 $$ sinkList
  result2 <- pipe2 $$ sinkList
  writeJson (opts' ^. #output) $ result1 `mappend` result2
  where
    opts' =
      if opts ^. #qiita || opts ^. #adventar then
        opts
      else
        opts & #qiita .~ True & #adventar .~ True
    pipe1 = pipe (opts' ^. #qiita) $ qiita (opts' ^. #year)
    pipe2 = pipe (opts' ^. #adventar) .
      adventar (opts' ^. #year) $ mkDriver (opts' ^. #wdHost) (opts' ^. #wdPort)

pipe :: ToPosts a => Bool -> a -> Source IO Post
pipe False = const $ yieldMany []
pipe True  = ($= filterC isHaskellPost) . getPosts

mdCmd :: MarkdownOptions -> IO ()
mdCmd opts = do
  result <- mconcat <$> mapM readJson (opts ^. #inputs)
  let
    md = T.unlines . intercalate [""] $ fmap toMarkdown result
    out = fromMaybe T.putStrLn $ (T.writeFile . T.unpack) <$> opts ^. #output
  out md
