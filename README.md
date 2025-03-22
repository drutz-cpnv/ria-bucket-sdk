# Bucket SDK

Ruby SDK for the Bucket Storage Service that allows you to upload and list files from a bucket service.

## Installation

Install the gem and add to the application's Gemfile by executing:

```
$ bundle add bucket_sdk
```

If bundler is not being used to manage dependencies, install the gem by executing:

```
$ gem install bucket_sdk
```

## Usage

### Initialize the client

```ruby
require 'bucket_sdk'

# Initialize the client with the base URL of the API
client = Bucket::Sdk.new(
  base_url: 'https://api.example.com',
  timeout: 60 # Optional, default is 60 seconds
)
```

### Upload an object

```ruby
# Upload a string to the bucket
response = client.upload_object(
  data: 'Hello, world!',
  destination: 'path/to/file.txt'
)

# Get the URL of the uploaded object
puts response.url
```

### List objects

```ruby
# List objects in the bucket
response = client.list_objects

# Get all objects
objects = response.objects

# List objects recursively
response = client.list_objects(recurse: true)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/example/bucket-sdk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/example/bucket-sdk/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bucket::Sdk project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/example/bucket-sdk/blob/main/CODE_OF_CONDUCT.md).
