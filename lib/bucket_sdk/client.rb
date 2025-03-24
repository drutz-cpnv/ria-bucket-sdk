# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "json"
require "tempfile"

module BucketSdk
  class Client
    attr_reader :base_url, :timeout

    def initialize(base_url:, timeout: 60)
      @base_url = base_url
      @timeout = timeout
    end

    # Upload an object to the bucket
    # @param file [File, String] The file to upload (either a File object or a path to a file)
    # @param destination [String] The destination path in the bucket
    # @return [Models::LoadResponse] The response containing the URL of the uploaded object
    def upload_object(file:, destination:)
      response = connection.post("/api/v2/objects") do |req|
        req.options.timeout = timeout

        # Set up multipart form data
        payload = {}

        if file.is_a?(File) || file.is_a?(Tempfile)
          payload[:file] = Faraday::Multipart::FilePart.new(file, "application/octet-stream")
        elsif file.is_a?(String) && File.exist?(file)
          # If a string is provided and it's a valid file path, open the file
          payload[:file] = Faraday::Multipart::FilePart.new(File.open(file, "r"), "application/octet-stream")
        else
          raise ArgumentError, "File must be a File object or a valid file path"
        end

        req.params[:destination] = destination
        req.body = payload
      end

      handle_response(response, BucketSdk::Models::LoadResponse)
    end

    # List objects in the bucket
    # @param recurse [Boolean] Whether to list objects recursively (default: false)
    # @return [Models::ListResponse] The list of objects
    def list_objects(recurse: false)
      response = connection.get("/api/v2/objects") do |req|
        req.params[:recurse] = recurse
      end

      handle_response(response, BucketSdk::Models::ListResponse)
    end

    private

    def connection
      @connection ||= Faraday.new(url: base_url) do |conn|
        conn.request :multipart
        conn.request :json

        conn.headers["Accept"] = "application/json"

        conn.options.timeout = timeout
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_response(response, model_class)
      case response.status
      when 200..299
        model_class.new(JSON.parse(response.body))
      when 422
        error_data = JSON.parse(response.body)
        raise BucketSdk::Models::ValidationError, error_data["detail"]
      else
        raise BucketSdk::Error, "API request failed with status #{response.status}: #{response.body}"
      end
    end
  end
end
