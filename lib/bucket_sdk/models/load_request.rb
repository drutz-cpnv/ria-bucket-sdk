# frozen_string_literal: true

module BucketSdk
    module Models
      class LoadRequest
        attr_reader :data, :destination

        def initialize(data:, destination:)
          @data = data
          @destination = destination
        end

        def to_h
          {
            data: data,
            destination: destination
          }
        end
      end
    end
  end