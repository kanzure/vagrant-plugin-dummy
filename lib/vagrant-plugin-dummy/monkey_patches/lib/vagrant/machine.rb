module Vagrant
  class Machine

    ssh_communicate = instance_method(:communicate)

    # This patch is needed until Vagrant supports a configurable communication channel
    define_method(:communicate) do
      unless @communicator
        if @config.vm.guest.eql? :dummy
          @logger.info("guest is #{@config.vm.guest}, using no communication channel")
          @communicator = false
        else
          @logger.info("guest is #{@config.vm.guest}, using SSH for communication channel")
          @communicator = ssh_communicate.bind(self).()
        end
      end
      @communicator
    end

    def is_dummy?
      return @config.vm.guest.eql? :dummy
    end

  end
end
