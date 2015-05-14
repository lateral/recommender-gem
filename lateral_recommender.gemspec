# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lateral_recommender/version'

Gem::Specification.new do |spec|
  spec.name          = 'lateral_recommender'
  spec.version       = LateralRecommender::VERSION
  spec.authors       = ['Max Novakovic']
  spec.email         = ['max@lateral.io']
  spec.summary       = 'Wrapper around the Lateral API.'
  spec.homepage      = 'https://github.com/lateral/recommender-gem'
  spec.license       = 'MIT'

  spec.files = `git ls-files`.split("\n")
  spec.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'awesome_print', '~> 1.6', '>= 1.6.1'
  spec.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'vcr', '~> 2.9', '>= 2.9.3'
  spec.add_development_dependency 'webmock', '~> 1.21', '>= 1.21.0'
  spec.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7.6'

  spec.add_runtime_dependency 'httparty', '~> 0.13', '>= 0.13.4'
  spec.add_runtime_dependency 'json', '~> 1.8', '>= 1.8.2'
end
