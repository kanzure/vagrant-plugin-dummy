require 'vagrant/errors'

module VagrantPluginDummy
  module Errors
    class VagrantPluginDummyError < ::Vagrant::Errors::VagrantError
      error_namespace("vagrant_plugin_dummy.errors")
    end

    class PluginDummyError < VagrantPluginDummyError
      error_key(:plugin_dummy_error)
    end
end
