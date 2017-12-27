{-# LANGUAGE OverloadedLabels  #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import           AdventCalendar
import           Control.Lens        ((&), (.~), (^.))
import           Options
import           Options.Applicative (execParser)

main :: IO ()
main = do
  opts <- execParser $
    optsParser `withInfo` "get Haskell posts on Advent Calendar"
  let
    opts' =
      if opts ^. #qiita || opts ^. #adventar then
        opts
      else
        opts & #qiita .~ True & #adventar .~ True
  result1 <- run (opts' ^. #qiita) $ qiita (opts' ^. #year)
  result2 <- run (opts' ^. #adventar) .
    adventar (opts' ^. #year) $ mkDriver (opts' ^. #wdHost) (opts' ^. #wdPort)
  writeJson "./hoge.json" $ result1 `mappend` result2

run :: ToPosts a => Bool -> a -> IO [Post]
run False = const $ pure []
run True  = getPosts
