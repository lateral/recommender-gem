require 'env_vars' unless ENV.include? 'TRAVIS_BUILD_ID'
# require 'vcr'
require 'ap'
require 'lateral_recommender'
# require 'webmock/rspec'

# VCR.configure do |c|
#   c.cassette_library_dir = 'spec/fixtures/tapes'
#   c.hook_into :webmock
#   c.filter_sensitive_data('<API_KEY>') { ENV['API_KEY'] }
# end
