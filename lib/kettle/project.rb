require 'yaml'
require 'uri'
require 'fileutils'
require 'kettle'

module Kettle
  class Project
    attr_reader :config

    def initialize(**config)
      @config = defaults.merge(config)

      init if @config[:init]
    end

    def init
      FileUtils.mkdir_p([sources, kettleroot])
      FileUtils.touch([managed_sources_file, template_data_file])
    end

    def defaults
      {
        :root       => File.expand_path(Dir.pwd),
        :init       => false,
        :deep_merge => false
      }
    end

    def template_data
      return @template_data if @template_data
      @template_data = YAML.load_file(template_data_file) if File.exist?(template_data_file)
      return @template_data || {}
    end

    def template_data_file
      config[:template_data_file] || File.join(config[:root], 'template_data.yaml')
    end

    def managed_sources_file
      config[:managed_sources_file] || File.join(config[:root], 'managed_sources.yaml')
    end

    def sources
      config[:sources] || File.join(config[:root], 'sources')
    end

    def source_object(name, source_config = {})
      uri = source_config[:repo] || URI(name)
      source_config[:repo] = name unless source_config[:repo]
      path = File.join(sources, uri.host, uri.path)
      Kettle::Source.new(path, source_config)
    end

    def managed_sources
      return @managed_sources if @managed_sources
      managed = File.exist?(managed_sources_file) ? YAML.load_file(managed_sources_file) : {}
      @managed_sources = managed.map { |name, source_config| source_object(name, source_config || {}) }
      return @managed_sources
    end

    def kettleroot
      config[:kettleroot] || File.join(config[:root], 'kettleroot')
    end

    def all_files
      Kettle.files(kettleroot)
    end

    def file_list
      all_files.select { |f| f unless File.directory?(f) }
    end

    def static_file_list
      file_list - template_list
    end

    def directory_list
      all_files - file_list
    end

    def template_list
      file_list.select { |f| f if File.extname(f) == '.erb' }
    end

    def templates
      return @templates if @templates
      @templates = template_list.map { |t| Kettle::Template.new(t) }
      return @templates || []
    end

    def update
      managed_sources.each do |source|
        source.scm.get
        Dir.chdir(source.path) do
          FileUtils.mkdir_p directory_list

          static_file_list.each do |f|
            FileUtils.cp(File.join(kettleroot, f), f)
          end

          templates.each do |template|
            File.open(File.join(kettleroot, template.name), 'r') do |content|
              File.open(template.path) do |f|
                f.write template.render(content, template_data, source.config)
              end
            end
          end
        end
      end
    end
  end
end
