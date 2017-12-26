# Haskell Advent Calendar 2017
Posts of Haskell Advent Calendar 2017 in Japan

## USAGE

```haskell
>> :set -XOverloadedStrings
>> import GHC.IO.Encoding
>> setLocaleEncoding utf8
>> result <- getPosts $ Qiita "https://qiita.com/advent-calendar/2017/haskell"
>> writeJson "./hoge.json" result
```
