# Igata #

## Getting set up ##

### Clone the repo & setting up submodules ###

```
$ git clone git@github.com:dockyard/igata.git
$ cd igata
$ git submodule init
$ git submodule update
```

This project uses [RVM](http://beginrescueend.com) to manage its Ruby
version.

Please install RVM if you don't have it already:

```
$ bash -s stable < <(curl -s
https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
```

If you already have RVM make sure you are using the latest version:

```
$ rvm get head && rvm reload
```

Make sure you have `Ruby-1.9.3-p0` installed:

```
$ rvm install ruby-1.9.3-p0
```

If you are on OSX Lion, you may need to build with clang:

(http://stackoverflow.com/questions/8032824/cant-install-ruby-under-lion-with-rvm-gcc-issues)

```
$ rvm install ruby-1.9.3-p0 --with-gcc=clang
```

Now you'll need to give RVM permission to append the `bundler_binstubs`
directory to your path:

```
$ chmod +x $rvm_path/hooks/after_cd_bundler
```

Install the app:

```
$ bundle install
```

Configure, create, migrate, and seed the database

```
$ cp config/database.yml.example config/database.yml
$ vim config/database.yml
$ rake db:reseed
```

Configure the settings:

```
$ cp config/settings.yml.example config/settings.yml
$ vim config/settings.yml
```

You need to set the Heroku usename to your actual Heroku username

## Development Notes ##

Requests specs which depend on javascript are run through the
capybara-webkit driver which requires that QT be installed. You can find
instructions for downloading and installing QT on the capybara-webkit
wiki.

(https://github.com/thoughtbot/capybara-webkit/wiki/Installing-QT)

## Production Notes ##

Deployed to Linode
