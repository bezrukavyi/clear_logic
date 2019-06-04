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
        @path ||= File.dirname(log_path)
      end

      def log_path
        @log_path ||= file_path.gsub('app', 'log').gsub(/\.[a-z]+$/, '.log')
      end

      def file_path
        @file_path ||= Thread.current.backtrace[2].split(':')[0]
      end

      def create_logger
        system('mkdir', '-p', path) unless Dir.exist?(path)

        logger_klass.new(log_path)
      end
    end
  end
end
