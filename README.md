# LateralRecommender

[![Build Status](https://travis-ci.org/lateral/recommender-gem.svg?branch=master)](https://travis-ci.org/lateral/recommender-gem)

This is a Ruby wrapper around the [Lateral API](https://lateral.io/api). It currently supports `add` and `near_text` from the [Recommender API](https://developers.lateral.io/docs/services/546b2cc23705a70f4cd2766d/operations/546b2e053705a70f4cd2766e) and the complete (experimental) [Personalisation API](https://developers.lateral.io/docs/services/54b7f0923705a712c0f43836/operations/54b7f3753705a712c0f4383f). Over time the missing API methods will be added and this will become a fully featured wrapper around the Lateral API.

*For the full API specification please see the [documentation here](https://developers.lateral.io/docs/services/).*

## Installation

Until the gem is more complete, it will not be available on rubygems.org. So to add it, add this line to your application's Gemfile:

	gem 'lateral_recommender', github: 'lateral/recommender-gem'

And then execute:

    $ bundle install

Or you can [install it manually](https://stackoverflow.com/questions/2577346/how-to-install-gem-from-github-source).

## Usage

### Get an API key

An API key is required in order to use our API. To do this, [sign up here](https://developers.lateral.io/signup/) then visit your [profile](https://developers.lateral.io/developer) and click 'Show' next to where it says `Primary key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`.

### Use the API

Initialize `LateralRecommender` with your API key by running:

```ruby
api = LateralRecommender::API.new YOUR_API_KEY
```

To add a document to the API call:

```ruby
api.add document_id: 'document_id', text: 'document text'
```

Please be aware that if you don't send enough meaningful text the API will return an error. So please ensure there is at least 100 or so words in the document you're adding.

To get recommendations for a document, use `near_text`:

```ruby
api.near_text text: 'document text'
```

This returns an array of Hashes containing a `document_id` and `distance`.

#### Querying our pre-populated data

If you don't want to insert your own documents to the API, you can query one of our pre-filled data sets:

* **[Movies](https://www.freebase.com/film/film?instances)** (experimental) - Movies listed on [Freebase](https://www.freebase.com/) with plots from [Wikipedia](https://en.wikipedia.org)
* **News** (experimental) - News from multiple outlets updated every 15 minutes
* **[arXiv](http://arxiv.org/)** - Academic papers in Physics, Mathematics, Computer Science, Quantitative Biology, Quantitative Finance and Statistics
* **[PubMed](http://www.ncbi.nlm.nih.gov/pubmed)** - Medical journals
* **[Wikipedia](https://en.wikipedia.org)** - General knowledge

To use these, simply initialize `LateralRecommender` with a second argument containing the corpus:

```ruby
api = LateralRecommender::API.new YOUR_API_KEY, 'news'
```

The available values are `movies`, `news`, `arxiv`, `pubmed` or `wikipedia`. We plan to add more in the near future.

Now you can query the API using `near_text` or `near_user` without the need for populating the API with your own content:

```ruby
api.near_text text: 'document text'
```

#### Managing users

A feature of the API is to be able to add a representation of a user. The user is able to have many documents and when querying the API for recommendations you can specify the user and each of these documents will be used to get recommendations for that user.

*Note: This is an experimental feature of the API*

To add a user:

```ruby
api.add_user 'user_id'
```

To add a document to that user:

```ruby
api.add_user_document 'user_id', 'document_id', 'document text'
```

You can do this as many times as you want to build a more complete picture of the user. Then, to query for recommendations for that user:

```ruby
api.near_user 'user_id'
```

The response will be the same format as a `near_text`.

## Contributing

1. Fork it ( https://github.com/lateral/recommender-gem/fork )
2. Create `spec/env_vars.rb` file containing  `ENV['API_KEY'] = 'YOUR_KEY'`
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

### Testing

To test the gem, run `bundle exec rspec`. Note: your API key must be un-used.