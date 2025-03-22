# frozen_string_literal: true

RSpec.describe BucketSdk do
  it "has a version number" do
    expect(BucketSdk::VERSION).not_to be nil
  end

  describe ".new" do
    it "returns a new client instance" do
      client = BucketSdk.new(base_url: "https://api.example.com")
      expect(client).to be_a(BucketSdk::Client)
      expect(client.base_url).to eq("https://api.example.com")
    end
  end
end
