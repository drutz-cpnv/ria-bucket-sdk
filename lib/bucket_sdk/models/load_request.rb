# frozen_string_literal: true

module BucketSdk
  module Models
    class LoadRequest
      attr_reader :file, :destination

      # Initialize a new LoadRequest
      # @param file [File, String] The file to upload (either a File object or a path to a file)
      # @param destination [String] The destination path in the bucket
      def initialize(file:, destination:)
        @file = file
        @destination = destination
      end

      def to_h
        {
          file: file,
          destination: destination
        }
      end
    end
  end
end
