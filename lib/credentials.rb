require 'yaml'

class Credentials
  def initialize
    # Configure settings
    dir = File.join(File.dirname(__FILE__), "..")
    @config = YAML::load_file(File.join(dir, 'credentials.yml'))
  end

  def method_missing(meth, *args, &block)
    meth = meth

    if @config.include?(meth.to_s)
      @config[meth.to_s]
    else
      super
    end
  end
end
