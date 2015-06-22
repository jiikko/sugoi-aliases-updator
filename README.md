# SugoiAliasesUpdator

/etc/aliasesなファイルを読み込んで追加削除した結果を標準出力に出す。

## Installation

```ruby
gem 'sugoi_aliases_updator'
```

## Requirement
'ruby' ~> '2.1'

## Usage
```
$ cat /etc/aliases
bin:            root
daemon:         root
named:          root
nobody:         root
uucp:           root
www:            root, n905i.1214@gmail.com
ftp-bugs:       root
postfix:        root, n905i.1214@gmail.com

```

```
$ sugoi_aliases_updator /etc/aliases add test@exmple.net TO=www
bin:            root
daemon:         root
named:          root
nobody:         root
uucp:           root
www:            root, n905i.1214@gmail.com, test@exmple.net
ftp-bugs:       root
postfix:        root, n905i.1214@gmail.com
```

```
$ sugoi_aliases_updator /etc/aliases rm n905i.1214@gmail.com TO=www,postfix
bin:            root
daemon:         root
named:          root
nobody:         root
uucp:           root
www:            root
ftp-bugs:       root
postfix:        root
```
```
$ sugoi_aliases_updator /etc/aliases list n905i.1214@gmail.com
www,postfix
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/sugoi_aliases_updator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
