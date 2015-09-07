require 'git'

module Kettle
  module SCM
    class Git
      def initialize(path, **config)
        if File.exist?(path)
          @git = Git.open(path)
        end
      end

      def get
      end

      def diff
      end

      def push(message)
      end
    end
  end
end
