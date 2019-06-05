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
      context[:test] = [STUBS[0]]
      success(context)
    end

    def second_log(context)
      context[:test] += [STUBS[1]]
      success(context)
    end

    def third_log(context)
      context[:test] += [STUBS[2]]
      success(context)
    end
  end

  context 'Logger' do
    context 'Default logger' do
      it 'should contain first and third context hash' do
        result = DefaultLoggerService.call

        expect(result).to be_success
        expect(result.context.options[:test]).to match_array(DefaultLoggerService::STUBS)
      end
    end

    context 'Custom logger' do
      it 'should contain only first stub value' do
      end
    end
  end
end
