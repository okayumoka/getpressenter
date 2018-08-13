# getpressenter
Tool get text of "Press Enter" with web scraping

エンジニアライフ ( http://el.jibun.atmarkit.co.jp/ ) で連載されているWeb小説『Press Enter』をテキストファイルで保存します。

# How to use

Nokogiriをインストールします。

```
gem install nokogiri
```

`getpressenter.rb`を実行します。

```
ruby getpressenter.rb
```

実行ディレクトリに `output` ディレクトリが作成され、その配下にテキストファイルで保存されます。
