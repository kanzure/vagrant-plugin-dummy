require "vagrant"

module VagrantPluginDummy
  module Guest
    class Dummy < Vagrant.plugin("2", :guest)

      # Vagrant 1.1.x compatibibility methods
      # Implement the 1.1.x methods and call through to the new 1.2.x capabilities

      attr_reader :machine

      def initialize(machine = nil)
        super(machine) unless machine == nil
        @machine = machine
      end

      def change_host_name(name)
        false
      end

      def distro_dispatch
        :dummy
      end

      def halt
        false
      end

      def mount_virtualbox_shared_folder(name, guestpath, options)
        false
      end

      def mount_vmware_shared_folder(name, guestpath, options)
        false
      end

      def configure_networks(networks)
        false
      end

      # Vagrant 1.2.x compatibibility methods

      def detect?(machine)
        @machine.communicate.test("")
      end
    end
  end
end
