# Haskell Advent Calendar 2017
Posts of Haskell Advent Calendar 2017 in Japan

## USAGE

### Qiita

```haskell
>> :set -XOverloadedStrings
>> import GHC.IO.Encoding
>> setLocaleEncoding utf8
>> result <- getPosts $ Qiita "https://qiita.com/advent-calendar/2017/calendars"
>> writeJson "./hoge.json" $ filter isHaskellPost result
```

### Adventar

run selenium with chrome webdriver.

```
$ $ java -jar ./selenium-server-standalone-*.jar
```

and exec on ghci

```haskell
>> :set -XOverloadedStrings
>> import GHC.IO.Encoding
>> setLocaleEncoding utf8
>> result <- getPosts $ Adventar "https://adventar.org/calendars?year=2017" (mkDriver "localhost" 4444)
>> writeJson "./hoge.json" $ filter isHaskellPost result
```
