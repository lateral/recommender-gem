# LateralRecommender

[![Build Status](https://travis-ci.org/lateral/recommender-gem.svg?branch=master)](https://travis-ci.org/lateral/recommender-gem)  ![Gem Version](https://badge.fury.io/rb/lateral_recommender.svg) [![Yard Docs](http://img.shields.io/badge/yard-docs-blue.svg)](http://rubydoc.info/github/lateral/recommender-gem/master)


This is a Ruby wrapper around the [Lateral](https://lateral.io/) [Conceptual text-matching API](https://lateral.io/docs/text-matching). At the moment it only supports [/add](https://lateral.io/docs/text-matching/api-reference#add-document-post), [/recommend-by-text](https://lateral.io/docs/text-matching/api-reference#recommend-by-text-post), [/recommend-by-id](https://lateral.io/docs/text-matching/api-reference#recommend-by-id-post) and our [pre-populated recommenders](https://lateral.io/docs/text-matching/pre-populated-recommenders). You can find the full API reference [here](https://lateral.io/docs/text-matching/api-reference).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lateral_recommender'
```

And then execute:

	$ bundle install

## Usage

### Get an API key

An API key is required in order to use our API. To do this go to our [docs page](https://lateral.io/docs) and click the 'Get Access' button in the top right. Choose the 'Conceptual text-matcher' API and you'll get emailed details of how to get your key.

### Use the API

Initialize `LateralRecommender` with your API key by running:

```ruby
api = LateralRecommender::API.new YOUR_API_KEY
```

#### Add a document

To add a document to the API call:

```ruby
api.add document_id: 'document_id', text: 'document text'
```

Please be aware that if you don't send enough meaningful text the API will return an error. So please ensure there is at least 100 or so words in the document you're adding.

#### Recommend by text

To get recommendations for some text, use `recommend_by_text`:

```ruby
api.recommend_by_text 'document text'
```

#### Recommend by ID

To get recommendations for a document that's in the API, use `recommend_by_id`:

```ruby
api.recommend_by_id 'document_id'
```
This returns an array of Hashes containing a `document_id` and `distance`.

#### Pre-populated recommenders

If you don't want to insert your own documents to the API, you can query one of our pre-populated recommenders:

* **[arXiv](https://lateral.io/docs/text-matching/pre-populated-recommenders#arxiv)** - 1M+ academic papers in Physics, Mathematics and Computer Science (updated daily)
* **[News](https://lateral.io/docs/text-matching/pre-populated-recommenders#news)** - 250,000+ curated news articles (updated every 15mins)
* **[PubMed](https://lateral.io/docs/text-matching/pre-populated-recommenders#pubmed)** - Medical journals
* **[SEC Data](https://lateral.io/docs/text-matching/pre-populated-recommenders#sec-data)** - 6,000+ yearly financial reports / 10-K filings (from 2014)
* **[Wikipedia](https://lateral.io/docs/text-matching/pre-populated-recommenders#wikipedia)** - 463,000 Wikipedia pages (which had 20+ page views in 2013)

To use one of these, initialize `LateralRecommender` with a second argument containing the corpus:

```ruby
api = LateralRecommender::API.new YOUR_API_KEY, 'news'
```

The available values are `arxiv`, `news`, `pubmed`, `sec` or `wikipedia`. These allow you to query the recommender using `recommend_by_text` or `recommend_by_id` without the need for adding your own documents. By text:

```ruby
api.recommend_by_text 'document text'
```

Or with a document ID:

```ruby
api.recommend_by_id 'arxiv-http://arxiv.org/abs/1403.2165'
```

Note: For the SEC data, you need to set a collections array:

```ruby
api.recommend_by_text 'document text', collections: '["item1a"]'
```

Read the [Pre-populated-recommenders documentation](https://lateral.io/docs/text-matching/pre-populated-recommenders#top) for more.

## Contributing

1. Fork it ( https://github.com/lateral/recommender-gem/fork )
2. Create `spec/env_vars.rb` file containing  `ENV['API_KEY'] = 'YOUR_KEY'`
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

### Testing

To test the gem, run `bundle exec rspec`. Note: your API key must be un-used.
