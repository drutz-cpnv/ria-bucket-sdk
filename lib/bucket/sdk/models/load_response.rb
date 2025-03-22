# frozen_string_literal: true

module Bucket
  module Sdk
    module Models
      class LoadResponse
        attr_reader :url

        def initialize(data)
          @url = data["url"]
        end

        def to_h
          {
            url: url
          }
        end
      end
    end
  end
end 