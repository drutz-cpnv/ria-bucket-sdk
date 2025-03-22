# frozen_string_literal: true

module Bucket
  module Sdk
    module Models
      class ListResponse
        attr_reader :objects

        def initialize(data)
          @objects = data["objects"] || []
        end

        def to_h
          {
            objects: objects
          }
        end
      end
    end
  end
end 