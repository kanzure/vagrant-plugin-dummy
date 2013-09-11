vagrant-plugin-dummy
==========================

This is a "dummy guest" plugin for vagrant. This is useful if you want to only
use vagrant for creating and destroying clean guests.

NOTE: This uses the provider to check if the guest is online before returning
to vagrant. This check only works with VirtualBox at the moment.

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

Add this to a Vagrantfile:

```
config.vm.guest :dummy
```

and

```
config.vm.synced_folder ".", "/vagrant", :disabled => true
```
