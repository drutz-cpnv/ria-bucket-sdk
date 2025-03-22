# frozen_string_literal: true

require_relative "sdk/version"

module Bucket
  # SDK for interacting with the Bucket API
  module Sdk
    class Error < StandardError; end

    # Creates a new client instance
    # @param base_url [String] The base URL of the API
    # @param timeout [Integer] The timeout in seconds for API requests
    # @return [Bucket::Sdk::Client] A new client instance
    def self.new(base_url:, timeout: 60)
      Client.new(base_url: base_url, timeout: timeout)
    end
  end
end

require_relative "sdk/models"
require_relative "sdk/client"
