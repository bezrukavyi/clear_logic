# frozen_string_literal: true

RSpec.describe ClearLogic::Result do
  CUSTOM_ERRORS = %i[first_custom_error second_custom_error].freeze

  before(:all) do
    class TestContext
      attr_accessor :failure_error
    end

    class TestResult
      include ClearLogic::Result

      errors *CUSTOM_ERRORS
    end
  end

  let(:context) { TestContext.new }
  let(:instance) { TestResult.new }

  (described_class::DEFAULT_ERRORS + CUSTOM_ERRORS).each do |name|
    describe "##{name}" do
      it 'should return failure monad' do
        result = instance.send(name, context)

        expect(result.is_a?(ClearLogic::Result::Failure)).to be_truthy
        expect(result.failure?).to be_truthy
        expect(result.value).to eq(context)
        expect(context.failure_error.status).to eq(name)
      end
    end
  end
end
