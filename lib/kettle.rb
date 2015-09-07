require 'kettle/project'
require 'kettle/source'
require 'kettle/template'
require 'kettle/version'

module Kettle
  class << self
    def files(directory)
      Dir.chdir(directory) do
        Dir.glob("**/*", File::FNM_DOTMATCH).select { |f| f unless File.basename(f) == '.' && '..' }
      end
    end
  end
end
