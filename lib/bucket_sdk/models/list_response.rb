# frozen_string_literal: true

module BucketSdk
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