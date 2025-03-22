#!/usr/bin/env ruby
# frozen_string_literal: true

require "bucket_sdk"

# Initialize the client
client = BucketSdk.new(
  base_url: "https://api.example.com"
)

# Upload an object
begin
  response = client.upload_object(
    data: "Hello, world!",
    destination: "path/to/file.txt"
  )
  puts "File uploaded successfully. URL: #{response.url}"
rescue BucketSdk::Error => e
  puts "Error uploading file: #{e.message}"
end

# List objects
begin
  response = client.list_objects
  puts "Objects in bucket:"
  response.objects.each do |object|
    puts "- #{object.inspect}"
  end
  
  # List objects recursively
  response = client.list_objects(recurse: true)
  puts "\nAll objects (recursive):"
  response.objects.each do |object|
    puts "- #{object.inspect}"
  end
rescue BucketSdk::Error => e
  puts "Error listing objects: #{e.message}"
end 