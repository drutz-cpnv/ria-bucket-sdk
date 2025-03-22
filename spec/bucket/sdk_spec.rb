# frozen_string_literal: true

RSpec.describe Bucket::Sdk do
  it "has a version number" do
    expect(Bucket::Sdk::VERSION).not_to be nil
  end

  describe ".new" do
    it "returns a new client instance" do
      client = Bucket::Sdk.new(base_url: "https://api.example.com")
      expect(client).to be_a(Bucket::Sdk::Client)
      expect(client.base_url).to eq("https://api.example.com")
    end
  end
end
