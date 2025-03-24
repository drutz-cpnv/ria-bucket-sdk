#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/setup"
require "bucket_sdk"

# Initialize the client
client = BucketSdk::Client.new(base_url: "http://localhost:8000")

# Upload a file from disk using File object
file_path = "README.md"
destination = "uploads/readme.md"
puts "Uploading #{file_path} to #{destination} using File object"

begin
  response = client.upload_object(
    file: File.open(file_path, "r"),
    destination: destination
  )
  puts "File uploaded successfully!"
  puts "URL: #{response.url}"
rescue StandardError => e
  puts "Error uploading file: #{e.message}"
end

# Upload a file from disk using file path
file_path = "README.md"
destination = "uploads/readme2.md"
puts "\nUploading #{file_path} to #{destination} using file path"

begin
  response = client.upload_object(
    file: file_path,
    destination: destination
  )
  puts "File uploaded successfully!"
  puts "URL: #{response.url}"
rescue StandardError => e
  puts "Error uploading file: #{e.message}"
end

# Create a temporary file and upload it
puts "\nUploading temporary file"
temp_file = Tempfile.new("example")
begin
  temp_file.write("Hello, world!")
  temp_file.rewind

  response = client.upload_object(
    file: temp_file,
    destination: "uploads/temp.txt"
  )
  puts "Temporary file uploaded successfully!"
  puts "URL: #{response.url}"
rescue StandardError => e
  puts "Error uploading temporary file: #{e.message}"
ensure
  temp_file.close
  temp_file.unlink
end

# List objects
puts "\nListing objects:"
begin
  response = client.list_objects(recurse: true)
  puts "Total objects: #{response.objects.count}"
  response.objects.each do |obj|
    puts "- #{obj.inspect}"
  end
rescue StandardError => e
  puts "Error listing objects: #{e.message}"
end
