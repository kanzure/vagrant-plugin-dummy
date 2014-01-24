require 'log4r'

module VagrantPluginDummy
  module Guest
    module Cap
      class ConfigureNetworks

        @@logger = Log4r::Logger.new("vagrant_plugin_dummy::guest::cap::configure_networks")

        def self.configure_networks(machine, networks)
          @@logger.debug("networks: #{networks.inspect}")
          @@logger.warn('This is just DUMMY method.')
          @@logger.warn('You will need to manually configure the network adapter.')
          exit(0)
        end
      end
    end
  end
end
