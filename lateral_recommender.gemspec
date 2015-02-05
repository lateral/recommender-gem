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

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'yard'

  spec.add_runtime_dependency 'httpclient'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'activesupport'
end
