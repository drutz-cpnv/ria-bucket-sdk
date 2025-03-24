# frozen_string_literal: true

require "spec_helper"

RSpec.describe BucketSdk::Client do
  let(:base_url) { "https://api.example.com" }
  let(:client) { described_class.new(base_url: base_url) }

  describe "#upload_object" do
    let(:file_content) { "Hello, world!" }
    let(:destination) { "path/to/file.txt" }
    let(:response_body) { { "url" => "https://cdn.example.com/path/to/file.txt" }.to_json }
    let(:status) { 200 }
    let(:temp_file) { Tempfile.new("test_upload") }

    before do
      temp_file.write(file_content)
      temp_file.rewind
    end

    after do
      temp_file.close
      temp_file.unlink
    end

    context "when uploading a File object" do
      before do
        stub_request(:post, "#{base_url}/api/v2/objects")
          .with(
            headers: {
              "Accept" => "application/json",
              "Content-Type" => %r{multipart/form-data}
            },
            query: { destination: destination }
          )
          .to_return(
            status: status,
            body: response_body,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "uploads a file to the bucket" do
        response = client.upload_object(file: temp_file, destination: destination)
        expect(response).to be_a(BucketSdk::Models::LoadResponse)
        expect(response.url).to eq("https://cdn.example.com/path/to/file.txt")
      end
    end

    context "when uploading a file path" do
      let(:file_path) { "spec/fixtures/test_file.txt" }

      before do
        allow(File).to receive(:exist?).with(file_path).and_return(true)
        allow(File).to receive(:open).with(file_path, "r").and_return(temp_file)

        stub_request(:post, "#{base_url}/api/v2/objects")
          .with(
            headers: {
              "Accept" => "application/json",
              "Content-Type" => %r{multipart/form-data}
            },
            query: { destination: destination }
          )
          .to_return(
            status: status,
            body: response_body,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "uploads a file to the bucket using a file path" do
        response = client.upload_object(file: file_path, destination: destination)
        expect(response).to be_a(BucketSdk::Models::LoadResponse)
        expect(response.url).to eq("https://cdn.example.com/path/to/file.txt")
      end
    end

    context "when providing an invalid file" do
      it "raises an ArgumentError" do
        expect do
          client.upload_object(file: "not_a_real_file.txt", destination: destination)
        end.to raise_error(ArgumentError, "File must be a File object or a valid file path")
      end
    end

    context "when validation error occurs" do
      let(:status) { 422 }
      let(:response_body) do
        {
          "detail" => [
            {
              "loc" => %w[body destination],
              "msg" => "field required",
              "type" => "value_error.missing"
            }
          ]
        }.to_json
      end

      before do
        stub_request(:post, "#{base_url}/api/v2/objects")
          .with(
            headers: {
              "Accept" => "application/json",
              "Content-Type" => %r{multipart/form-data}
            },
            query: { destination: destination }
          )
          .to_return(
            status: status,
            body: response_body,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "raises a ValidationError" do
        expect do
          client.upload_object(file: temp_file, destination: destination)
        end.to raise_error(BucketSdk::Models::ValidationError)
      end
    end
  end

  describe "#list_objects" do
    let(:objects) { [{ "name" => "file1.txt" }, { "name" => "file2.txt" }] }
    let(:response_body) { { "objects" => objects }.to_json }
    let(:recurse) { false }

    before do
      stub_request(:get, "#{base_url}/api/v2/objects")
        .with(
          query: { recurse: recurse },
          headers: {
            "Accept" => "application/json"
          }
        )
        .to_return(
          status: 200,
          body: response_body,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "lists objects in the bucket" do
      response = client.list_objects(recurse: recurse)
      expect(response).to be_a(BucketSdk::Models::ListResponse)
      expect(response.objects).to eq(objects)
    end

    context "when recurse is true" do
      let(:recurse) { true }

      it "includes recurse parameter in request" do
        client.list_objects(recurse: recurse)
        expect(WebMock).to have_requested(
          :get, "#{base_url}/api/v2/objects"
        ).with(query: { recurse: true })
      end
    end
  end
end
