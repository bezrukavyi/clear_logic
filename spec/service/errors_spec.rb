# frozen_string_literal: true

RSpec.describe ClearLogic::Service do
  let(:stub_name) { FFaker::Lorem.word }

  class ErrorsService < ClearLogic::Service
    errors :danger

    step :test

    def test(context)
      danger(context)
    end
  end

  context 'Errors' do
    it 'should retur custom error' do
      result = ErrorsService.call

      expect(result).to be_failure
      expect(result.context.failure_error.status).to eq(:danger)
    end
  end

  context 'Logger' do
    it 'should retur custom error' do
      result = ErrorsService.call

      expect(result).to be_failure
      expect(result.context.failure_error.status).to eq(:danger)
    end
  end
end
