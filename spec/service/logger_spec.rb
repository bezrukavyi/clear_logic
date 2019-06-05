# frozen_string_literal: true

RSpec.describe ClearLogic::Service do
  class DefaultLoggerService < ClearLogic::Service
    STUBS = [
      FFaker::Lorem.word,
      FFaker::Lorem.word,
      FFaker::Lorem.word
    ]

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

  let(:file_path) { 'log/clear_logic/logger/default.log' }
  let(:file) { File.read(file_path) }

  after(:each) do
    File.delete(file_path) if File.exist?(file_path)
  end

  context 'Logger' do
    context 'Default logger' do
      it 'should contain first and third context hash' do
        result = DefaultLoggerService.call

        expect(result).to be_success
        expect(file).to include(DefaultLoggerService::STUBS[0])
        expect(file).not_to include(DefaultLoggerService::STUBS[1])
        expect(file).to include(DefaultLoggerService::STUBS[2])
      end
    end
  end
end
