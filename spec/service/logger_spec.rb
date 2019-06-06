# frozen_string_literal: true

RSpec.describe ClearLogic::Service do
  STUBS = [
    FFaker::Lorem.word,
    FFaker::Lorem.word,
    FFaker::Lorem.word
  ].freeze

  class LoggerService < ClearLogic::Service
    stride :first_log, log: true
    stride :second_log
    stride :third_log, log: true

    def first_log(context)
      context[:test] = STUBS[0]
      success(context)
    end

    def second_log(context)
      context[:test] = STUBS[1]
      success(context)
    end

    def third_log(context)
      context[:test] = STUBS[2]
      success(context)
    end
  end

  class CustomLogger < ::Logger
    def format_message(_severity, _time, _progname, context)
      context[:test][0] + "\n"
    end
  end

  class CustomLoggerService < ClearLogic::Service
    logger CustomLogger

    stride :first, log: true
    stride :second, log: true

    def first(context)
      context[:test] = [STUBS[0]]
      success(context)
    end

    def second(context)
      context[:test] += [STUBS[1]]
      success(context)
    end
  end

  after(:each) do
    # File.delete(file_path) if File.exist?(file_path)
  end

  context 'Logger' do
    context 'Default logger' do
      let(:file_path) { 'log/logger_service.log' }
      let(:file) { File.read(file_path) }

      it 'should contain first and third context hash' do
        result = LoggerService.call

        expect(result).to be_success

        expect(file).to include(STUBS[0])
        expect(file).not_to include(STUBS[1])
        expect(file).to include(STUBS[2])
      end
    end

    context 'Custom logger' do
      let(:file_path) { 'log/custom_logger_service.log' }
      let(:file) { File.read(file_path) }

      it 'should contain first and third context hash' do
        result = CustomLoggerService.call

        expect(result).to be_success

        expect(file).to include(STUBS[0])
        expect(file).not_to include(STUBS[1])
      end
    end
  end
end
