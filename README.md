vagrant-guest-dummy
==========================

This is a "dummy" plugin for vagrant. This is useful if you want to only use vagrant for creating and destroying clean guests.

Installing vagrant-guest-dummy
==========================

### Installing from source

```
bundle install
bundle exec rake
vagrant plugin install pkg/vagrant-guest-dummy.gem
```

Usage
==========================

Addd this to a Vagrantfile:

```
config.vm.guest :dummy
```
