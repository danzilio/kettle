require 'yaml'
require 'kettle'

module Kettle
  class Source
    attr_reader :path, :dotfile

    def initialize(path, config = {})
      @path = File.expand_path(path)
      @config = config
      @dotfile = File.join(@path, '.kettle.yaml')
    end

    def dotfile_config
      return @dotfile_config if @dotfile_config
      @dotfile_config = YAML.load_file(dotfile) if File.exist?(dotfile)
      return @dotfile_config || {}
    end

    def config
      @config.merge(dotfile_config)
    end

    def files
      Kettle.files(path) if File.exist?(path)
    end

    def scm
      Kettle::SCM::Git.new(path, config[:scm])
    end
  end
end
