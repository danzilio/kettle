module Kettle
  class Config
    def initialize
      if block_given?
        yield
      else
        config_file = "#{Dir.pwd}/kettle.yaml"
        load_config(config_file)
      end
    end
  end
end
