require 'erb'

module Kettle
  class Template
    attr_reader :path, :name
    def initialize(name)
      @name = name
      dir,file = File.split(name)
      @path = File.join(dir, File.basename(file, '.erb'))
    end

    def render(content, left_config, right_config)
      @all = left_config.merge(right_config)
      @config = @all[path]
      erb = ERB.new(content, nil, '-')
      erb.def_method(Template, 'generate()')
      self.generate()
    end
  end
end
