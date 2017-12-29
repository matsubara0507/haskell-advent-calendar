# Haskell Advent Calendar
Posts of Haskell Advent Calendar in Japan

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
$ java -jar ./selenium-server-standalone-*.jar
```

and exec on ghci

```haskell
>> :set -XOverloadedStrings
>> import GHC.IO.Encoding
>> setLocaleEncoding utf8
>> result <- getPosts $ Adventar "https://adventar.org/calendars?year=2017" (mkDriver "localhost" 4444)
>> writeJson "./hoge.json" $ filter isHaskellPost result
```

### Command

run selenium with chrome webdriver and:

```
$ stack exec -- advent-calendar fetch 2017 "./out/hoge.json"
```

### To Markdown

```
$ stack exec -- advent-calendar markdown "./out/qiita.json" "./out/adventar.json" -o "./out/posts.md"
```
