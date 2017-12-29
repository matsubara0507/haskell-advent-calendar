# Haskell Advent Calendar
Posts of Haskell Advent Calendar in Japan

## USAGE

run selenium with chrome webdriver (on ADVENTAR).

```
$ java -jar ./selenium-server-standalone-*.jar
```

and:

```
$ stack exec -- advent-calendar fetch 2017 "./out/hoge.json"
```

### To Markdown

```
$ stack exec -- advent-calendar markdown "./out/qiita.json" "./out/adventar.json" -o "./out/posts.md"
```
