module ClearLogic
  module Logger
    class Default < ::Logger
      DATE_FORMAT = '%y-%m-%d %H:%M:%S.%3N '.freeze
      FORMAT = "[%s#%d#%d] %5s -- %s: %s\n".freeze

      def format_message(severity, time, progname, context)
        thread_id = Thread.current.object_id % 100_000

        format(FORMAT, format_datetime(time), Process.pid, thread_id, severity, progname, pretty_view(context))
      end

      private

      def format_datetime(time)
        time.strftime(DATE_FORMAT)
      end

      def pretty_view(context)
        JSON.pretty_generate(context.to_h)
      end
    end
  end
end
