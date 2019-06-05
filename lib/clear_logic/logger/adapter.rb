# frozen_string_literal: true

module ClearLogic
  module Logger
    class Adapter
      attr_reader :logger_klass, :log_path

      def initialize(logger_klass, log_path = nil)
        @logger_klass = logger_klass
        @log_path = log_path || default_log_path
      end

      def logger
        @logger ||= create_logger
      end

      private

      def create_logger
        system('mkdir', '-p', path) unless Dir.exist?(path)

        logger_klass.new(log_path)
      end

      def path
        File.dirname(log_path)
      end

      def default_log_path
        file_name = Dry::Inflector.new.underscore(logger_klass.name.gsub('::', '/'))
        File.join(ENV['BUNDLE_GEMFILE'], "log/#{file_name}.log").gsub!('Gemfile/', '')
      end
    end
  end
end
