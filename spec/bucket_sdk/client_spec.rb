# frozen_string_literal: true

require "spec_helper"

RSpec.describe BucketSdk::Client do
  let(:base_url) { "https://api.example.com" }
  let(:client) { described_class.new(base_url: base_url) }

  describe "#upload_object" do
    let(:data) { "Hello, world!" }
    let(:destination) { "path/to/file.txt" }
    let(:response_body) { { "url" => "https://cdn.example.com/path/to/file.txt" }.to_json }
    let(:status) { 200 }

    before do
      stub_request(:post, "#{base_url}/api/v2/objects")
        .with(
          body: { data: data, destination: destination }.to_json,
          headers: {
            "Content-Type" => "application/json",
            "Accept" => "application/json"
          }
        )
        .to_return(
          status: status,
          body: response_body,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "uploads an object to the bucket" do
      response = client.upload_object(data: data, destination: destination)
      expect(response).to be_a(BucketSdk::Models::LoadResponse)
      expect(response.url).to eq("https://cdn.example.com/path/to/file.txt")
    end

    context "when validation error occurs" do
      let(:status) { 422 }
      let(:response_body) do
        {
          "detail" => [
            {
              "loc" => ["body", "destination"],
              "msg" => "field required",
              "type" => "value_error.missing"
            }
          ]
        }.to_json
      end

      it "raises a ValidationError" do
        expect {
          client.upload_object(data: data, destination: destination)
        }.to raise_error(BucketSdk::Models::ValidationError)
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
