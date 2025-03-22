# frozen_string_literal: true

require_relative "bucket_sdk/version"

module BucketSdk
    class Error < StandardError; end

    # Creates a new client instance
    # @param base_url [String] The base URL of the API
    # @param timeout [Integer] The timeout in seconds for API requests
    # @return [Bucket::Sdk::Client] A new client instance
    def self.new(base_url:, timeout: 60)
      Client.new(base_url: base_url, timeout: timeout)
    end
  end

require_relative "bucket_sdk/models"
require_relative "bucket_sdk/client"
