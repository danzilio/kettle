module Kettle
  class Project
    attr_reader :project_config

    def initialize(project_config)
      @project_config = project_config
    end

    def config
      @config ||= defaults.merge(project_config)
    end

    def defaults
      {
        :root => File.join(Dir.pwd, 'kettleroot'),
        :managed_repos => File.join(Dir.pwd, 'managed_repos.yaml')
      }
    end

    def files
      @files ||= Dir.chdir(config[:root]) do
        raw_files = Dir.glob("**/*", File::FNM_DOTMATCH) - %w(. ..)
        raw_files.select { |f| f unless File.directory?(f) }
      end
    end

    def templates
      @templates ||= files.select { |f| f if File.extname(f) == '.erb' }
    end

    def static_files
      files - templates
    end
  end
end
