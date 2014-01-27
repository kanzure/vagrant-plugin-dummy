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
        provider = @machine.provider_name.id2name
        # NOTE: There is no timeout here.  We should probably have one...
        if provider == 'virtualbox'
          return ready_virtualbox?
        elsif provider == 'vmware_workstation' or provider == 'vmware_fusion'
          return ready_vmware?
        end
      end

      def ready_virtualbox?
        @logger.debug("Checking the status of NIC 0")
        nic_0_status = ''
        while nic_0_status !~ /Up/ do
          nic_0_status = @machine.provider.driver.execute('guestproperty', 'get', @machine.id, '/VirtualBox/GuestInfo/Net/0/Status') || ''
          @logger.debug("NIC 0 Status: "+ nic_0_status)
        end
        return true
      end

      def ready_vmware?
        @logger.debug("Checking if IP address is assigned")
        ip = nil
        while not ip do
          ip = nil
          begin
              resp =  @machine.provider.driver.send(:vmrun, *['getGuestIPAddress', @machine.id])
          rescue Exception => e
              @logger.warn(e.message)
          else
              m = /(?<ip>\d{1,3}\.\d{1,3}.\d{1,3}\.\d{1,3})/.match(resp.stdout)
              ip = (resp.exit_code == 0 and m) ? m['ip'] : nil
          end
          @logger.debug("Machine IP: #{ip}")
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
