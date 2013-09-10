begin
  require "vagrant"
rescue LoadError
  raise "The vagrant-plugin-dummy vagrant plugin must be run with vagrant."
end

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.1.0"
  raise "The vagrant-plugin-dummy vagrant plugin is only compatible with Vagrant 1.1+"
end

# Monkey Patch the VM object to support a non-existing communication channel
# TODO: is this necessary?
require_relative "monkey_patches/lib/vagrant/machine"

module VagrantPluginDummy
  class Plugin < Vagrant.plugin("2")
    name "Dummy guest"
    description <<-DESC
    This plugin installs a provider that tries its best to not touch the
    machine.
    DESC

    guest(:dummy) do
      require_relative "guest/dummy"
      VagrantPluginDummy::Guest::Dummy
    end

    # Vagrant 1.2 introduced the concept of capabilities instead of implementing
    # an interface on the guest.
#    if Vagrant::VERSION >= "1.2.0"
#
#      guest_capability(:windows, :change_host_name) do
#        require_relative "guest/cap/change_host_name"
#        VagrantPluginDummy::Guest::Cap::ChangeHostName
#      end
#
#      guest_capability(:windows, :configure_networks) do
#        require_relative "guest/cap/configure_networks"
#        VagrantPluginDummy::Guest::Cap::ConfigureNetworks
#      end
#
#      guest_capability(:windows, :halt) do
#        require_relative "guest/cap/halt"
#        VagrantPluginDummy::Guest::Cap::Halt
#      end
#
#      guest_capability(:windows, :mount_virtualbox_shared_folder) do
#        require_relative "guest/cap/mount_virtualbox_shared_folder"
#        VagrantPluginDummy::Guest::Cap::MountVirtualBoxSharedFolder
#      end
#
#      guest_capability(:windows, :mount_vmware_shared_folder) do
#        require_relative "guest/cap/mount_vmware_shared_folder"
#        VagrantPluginDummy::Guest::Cap::MountVMwareSharedFolder
#      end
#
#    end

    # This initializes the internationalization strings.
    def self.setup_i18n
      I18n.load_path << File.expand_path("locales/en.yml", VagrantPluginDummy.vagrant_plugin_dummy_root)
      I18n.reload!
    end

    # This sets up our log level to be whatever VAGRANT_LOG is.
    def self.setup_logging
      require "log4r"

      level = nil
      begin
        level = Log4r.const_get(ENV["VAGRANT_LOG"].upcase)
      rescue NameError
        # This means that the logging constant wasn't found,
        # which is fine. We just keep `level` as `nil`. But
        # we tell the user.
        level = nil
      end

      # Some constants, such as "true" resolve to booleans, so the
      # above error checking doesn't catch it. This will check to make
      # sure that the log level is an integer, as Log4r requires.
      level = nil if !level.is_a?(Integer)

      # Set the logging level on all "vagrant" namespaced
      # logs as long as we have a valid level.
      if level
        logger = Log4r::Logger.new("vagrant_plugin_dummy")
        logger.outputters = Log4r::Outputter.stderr
        logger.level = level
        logger = nil
      end
    end

  end
end

VagrantPluginDummy::Plugin.setup_logging()
VagrantPluginDummy::Plugin.setup_i18n()
