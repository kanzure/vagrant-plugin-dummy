vagrant-plugin-dummy
==========================

This is a "dummy" plugin for vagrant. This is useful if you want to only use vagrant for creating and destroying clean guests.

Installing vagrant-plugin-dummy
==========================

### Installing from source

```
bundle install
bundle exec rake
vagrant plugin install pkg/vagrant-plugin-dummy-0.0.2.gem
```

Usage
==========================

Addd this to a Vagrantfile:

```
config.vm.guest :dummy
```

and

```
config.vm.synced_folder ".", "/vagrant", :disabled => true
```
