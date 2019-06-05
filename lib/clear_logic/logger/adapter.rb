# frozen_string_literal: true

module ClearLogic
  module Logger
    class Adapter
      attr_reader :logger_klass

      def initialize(logger_klass)
        @logger_klass = logger_klass
      end

      def logger
        @logger ||= create_logger
      end

      private

      def path
        File.dirname(log_path)
      end

      def log_path
        file_name = Dry::Inflector.new.underscore(logger_klass.name.gsub('::', '/'))
        File.join(ENV['BUNDLE_GEMFILE'], "log/#{file_name}.log").gsub!('Gemfile/', '')
      end

      def create_logger
        system('mkdir', '-p', path) unless Dir.exist?(path)

        logger_klass.new(log_path)
      end
    end
  end
end
