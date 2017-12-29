{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           AdventCalendar
import           Conduit
import           Control.Lens        ((&), (.~), (^.))
import           GHC.IO.Encoding
import           Options
import           Options.Applicative (execParser)

main :: IO ()
main = do
  setLocaleEncoding utf8
  opts <- execParser $
    optsParser `withInfo` "get Haskell posts on Advent Calendar"
  let
    opts' =
      if opts ^. #qiita || opts ^. #adventar then
        opts
      else
        opts & #qiita .~ True & #adventar .~ True
    pipe1 = pipe (opts' ^. #qiita) $ qiita (opts' ^. #year)
    pipe2 = pipe (opts' ^. #adventar) .
      adventar (opts' ^. #year) $ mkDriver (opts' ^. #wdHost) (opts' ^. #wdPort)
  result1 <- pipe1 $$ sinkList
  result2 <- pipe2 $$ sinkList
  writeJson (opts' ^. #output) $ result1 `mappend` result2

pipe :: ToPosts a => Bool -> a -> Source IO Post
pipe False = const $ yieldMany []
pipe True  = ($= filterC isHaskellPost) . getPosts
