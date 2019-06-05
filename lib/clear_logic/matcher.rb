# frozen_string_literal: true

module ClearLogic
  class Matcher
    CASES = %i[success failure].freeze

    def self.call(*args)
      new.matcher.call(*args) { |on| yield(on) }
    end

    def matcher
      dry_cases = CASES.each_with_object({}) do |one_case, case_list|
        case_list[one_case] = send("#{one_case}_case")
      end

      Dry::Matcher.new(dry_cases)
    end

    private

    def success_case
      Dry::Matcher::Case.new(
        match: ->(result) { result.success? },
        resolve: ->(result) { result }
      )
    end

    def failure_case
      Dry::Matcher::Case.new(
        match: ->(result, *patterns) { patterns.any? ? case_patterns(result, patterns) : result.failure? },
        resolve: ->(result) { result }
      )
    end

    def case_patterns(result, patterns)
      patterns.any? do |pattern|
        return false unless respond_to?("#{pattern}_pattern", private: true)

        send("#{pattern}_pattern", result)
      end
    end

    ClearLogic::Result::DEFAULT_ERRORS.each do |error_type|
      define_method "#{error_type}_pattern" do |result|
        return false unless result.failure?

        result.value.respond_to?(:failure_error) &&
          !result.value.failure_error.nil? &&
          result.value.failure_error.status == error_type
      end
    end
  end
end
