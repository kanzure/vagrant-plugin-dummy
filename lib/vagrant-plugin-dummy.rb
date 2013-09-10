require "pathname"

module VagrantPluginDummy

  def self.vagrant_plugin_dummy_root
    @vagrant_plugin_dummy_root ||= Pathname.new(File.expand_path("../../", __FILE__))
  end

  def self.load_script(script_file_name)
    File.read(expand_script_path(script_file_name))
  end

  def self.load_script_template(script_file_name, options)
    Vagrant::Util::TemplateRenderer.render(expand_script_path(script_file_name), options)
  end

  # TODO: unnecessary?
  def self.expand_script_path(script_file_name)
    File.expand_path("lib/vagrant-plugin-dummy/scripts/#{script_file_name}", VagrantPluginDummy.vagrant_plugin_dummy_root)
  end

end

require "vagrant-plugin-dummy/plugin"
