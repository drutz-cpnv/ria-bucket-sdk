# frozen_string_literal: true

module BucketSdk
  module Models
    class ValidationError < BucketSdk::Error
      attr_reader :details

      def initialize(details)
        @details = details
        super("Validation error: #{details.map { |d| "#{d["msg"]} at #{d["loc"].join(".")}" }.join(", ")}")
      end

      def to_h
        {
          details: details
        }
      end
    end
  end
end
