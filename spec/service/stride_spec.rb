# frozen_string_literal: true

RSpec.describe ClearLogic::Service do
  class StrideService < ClearLogic::Service
    context :options, Dry::Types['strict.hash'], as: :param

    STUBS = [
      FFaker::Lorem.word,
      FFaker::Lorem.word,
      FFaker::Lorem.word
    ].freeze

    stride :first, failure: :first_rollback
    stride :second, rescue: { StandardError => :second_rollback }
    stride :third, rescue: { StandardError => :third_rollback }, failure: :success

    def first(context)
      context[:test] = { first: STUBS[0] }
      return failure(context) if context.options[:first_rollback]

      success(context)
    end

    def second(context)
      context[:test].merge!(second: STUBS[1])
      raise StandardError if context.options[:raise_second]

      success(context)
    end

    def third(context)
      context[:test].merge!(third: STUBS[2])
      raise StandardError if context.options[:raise_third]
      return failure(context) if context.options[:third_rollback]

      success(context)
    end

    def first_rollback(context)
      context[:test].delete(:first)
      success(context)
    end

    def second_rollback(context)
      context[:test].delete(:second)
      failure(context)
    end

    def third_rollback(context)
      context[:test].delete(:third)
      failure(context)
    end
  end

  context 'Stride' do
    it 'should pass all steps' do
      result = StrideService.call({})

      expect(result).to be_success
      expect(result.context[:test].values).to match_array(StrideService::STUBS)
    end

    it 'should rollback first' do
      result = StrideService.call(first_rollback: true)

      expect(result).to be_success
      expect(result.context[:test].values).to match_array([StrideService::STUBS[1], StrideService::STUBS[2]])
    end

    it 'should raise second' do
      result = StrideService.call(raise_second: true)

      expect(result).to be_failure
      expect(result.context[:test].values).to match_array(StrideService::STUBS[0])
    end

    it 'should raise third' do
      result = StrideService.call(raise_third: true)

      expect(result).to be_failure
      expect(result.context[:test].values).to match_array([StrideService::STUBS[0], StrideService::STUBS[1]])
    end

    it 'should rollback third' do
      result = StrideService.call(third_rollback: true)

      expect(result).to be_success
      expect(result.context[:test].values).to match_array(StrideService::STUBS)
    end
  end
end
