module Main where

import           Options
import           Options.Applicative (execParser)

main :: IO ()
main = do
  opts <- execParser $
    optsParser `withInfo` "get Haskell posts on Advent Calendar"
  print opts
