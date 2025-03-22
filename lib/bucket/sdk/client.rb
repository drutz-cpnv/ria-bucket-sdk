# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require "json"

class Bucket::Sdk::Client
  attr_reader :base_url, :timeout

  def initialize(base_url:, timeout: 60)
    @base_url = base_url
    @timeout = timeout
  end

  # Upload an object to the bucket
  # @param data [String] The data to upload
  # @param destination [String] The destination path in the bucket
  # @return [Models::LoadResponse] The response containing the URL of the uploaded object
  def upload_object(data:, destination:)
    response = connection.post("/api/v2/objects") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = JSON.generate({
                                 data: data,
                                 destination: destination
                               })
    end

    handle_response(response, Models::LoadResponse)
  end

  # List objects in the bucket
  # @param recurse [Boolean] Whether to list objects recursively (default: false)
  # @return [Models::ListResponse] The list of objects
  def list_objects(recurse: false)
    response = connection.get("/api/v2/objects") do |req|
      req.params[:recurse] = recurse
    end

    handle_response(response, Models::ListResponse)
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
      raise Models::ValidationError.new(error_data["detail"])
    else
      raise Bucket::Sdk::Error, "API request failed with status #{response.status}: #{response.body}"
    end
  end
end