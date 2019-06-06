# frozen_string_literal: true

module ClearLogic
  module Logger
    class Adapter
      attr_reader :service_class, :logger_class, :log_path

      def initialize(service_class)
        @service_class = service_class
        @logger_class = service_class.logger_class
        @log_path = service_class.logger_options[:log_path] || default_log_path
      end

      def logger
        @logger ||= create_logger
      end

      private

      def create_logger
        system('mkdir', '-p', path) unless Dir.exist?(path)

        logger_class.new(log_path)
      end

      def path
        File.dirname(log_path)
      end

      def default_log_path
        file_name = Dry::Inflector.new.underscore(service_class.name.gsub('::', '/'))
        File.join(ENV['BUNDLE_GEMFILE'], "log/#{file_name}.log").gsub!('Gemfile/', '')
      end
    end
  end
end
