# frozen_string_literal: true

RSpec.describe ClearLogic::Matcher do
  ERRORS = %i[
    unauthorized
    forbidden
    not_found
    invalid
  ].freeze

  class TestMatcherResult
    include ClearLogic::Result

    errors :custom_error
  end

  def match_result(result)
    ClearLogic::Matcher.call(result) do |on|
      on.failure(:unauthorized) { :unauthorized_result }
      on.failure(:forbidden) { :forbidden_result }
      on.failure(:not_found) { :not_found_result }
      on.failure(:invalid) { :invalid_result }
      on.failure(:custom_error) { :custom_error_result }
      on.failure { :failure_result }
      on.success { :success_result }
    end
  end

  context 'Match default errors' do
    ERRORS.each do |name|
      context "#{name} match" do
        let(:failure_error) { double(:failure_error, status: name) }
        let(:context) { double(:context, 'failure_error=': nil, failure_error: failure_error) }

        it "should return '#{name}_result'" do
          result_instance = TestMatcherResult.new.send(name, context)

          result = match_result(result_instance)

          expect(result).to eq("#{name}_result".to_sym)
        end
      end
    end
  end

  context 'Match errors' do
    let(:context) { double(:context, 'failure_error=': nil, failure_error: nil) }

    it "should return 'failure_result'" do
      result_instance = TestMatcherResult.new.send(:failure, context)

      result = match_result(result_instance)

      expect(result).to eq(:failure_result)
    end
  end

  context 'Match success' do
    let(:context) { double(:context) }

    it "should return 'success_result'" do
      result_instance = TestMatcherResult.new.send(:success, context)

      result = match_result(result_instance)

      expect(result).to eq(:success_result)
    end
  end
end
