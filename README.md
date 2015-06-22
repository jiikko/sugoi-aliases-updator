# SugoiAliasesUpdator

/etc/aliases の更新をする。

## Installation

```ruby
gem 'sugoi_aliases_updator'
```

## Usage
```
$ cat /etc/aliases
# General redirections for pseudo accounts
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
# General redirections for pseudo accounts
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
$ sugoi_aliases_updator /etc/aliases rm test@exmple.net TO=www,postfix
# General redirections for pseudo accounts
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
