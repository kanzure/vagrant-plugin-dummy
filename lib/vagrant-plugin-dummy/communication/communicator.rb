require 'timeout'
require 'log4r'
require_relative '../errors'

module VagrantPluginDummy
  module Communication
    # Provides no communication with the machine.
    class DummyCommunicator < Vagrant.plugin("2", :communicator)

      attr_reader :logger
      attr_reader :machine

      def self.match?(machine)
        machine.config.vm.guest.eql? :dummy
      end

      def initialize(machine)
        @machine = machine
        @logger = Log4r::Logger.new("vagrant_plugin_dummy::communication::dummycommunicator")
        @logger.debug("initializing DummyCommunicator")
      end

      def ready?
        @machine = machine
        @logger.debug("Checking the status of NIC 0")
        # NOTE: There is no timeout here.  We should probably have one...
        @nic_0_status = ''
        while @nic_0_status !~ /Up/ do
            @nic_0_status = @machine.provider.driver.execute('guestproperty', 'get', @machine.id, '/VirtualBox/GuestInfo/Net/0/Status') || ''
            @logger.debug("NIC 0 Status: "+ @nic_0_status)
        end

        return true
      end

      def execute(command, opts={}, &block)
        @logger.warn("DummyCommunicator.execute isn't implemented")
        return 0
      end
      alias_method :sudo, :execute

      def test(command, opts=nil)
        return false unless @machine.config.vm.guest.eql? :dummy
      end

      def upload(from, to)
        @logger.warn("DummyCommunicator.upload isn't implemented")
      end

      def download(from, to=nil)
        @logger.warn("DummyCommunicator.download isn't implemented")
      end

      def session
        @session ||= new_session
      end
    end
  end
end
