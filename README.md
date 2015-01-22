# LateralRecommender

This is a Ruby wrapper around the [Lateral API](https://lateral.io/api). It currently supports `add` and `near_text` from the [Recommender API](https://developers.lateral.io/docs/services/546b2cc23705a70f4cd2766d/operations/546b2e053705a70f4cd2766e) and the complete (experimental) [Personalisation API](https://developers.lateral.io/docs/services/54b7f0923705a712c0f43836/operations/54b7f3753705a712c0f4383f). Over time the missing API methods will be added and this will become a fully featured wrapper around the Lateral API.

*For the full API specification please see the [documentation here](https://developers.lateral.io/docs/services/).*

## Installation

Add this line to your application's Gemfile:

    gem 'lateral_recommender'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lateral_recommender

## Usage

### Get an API key

An API key is required in order to use our API. To do this, [sign up here](https://developers.lateral.io/signup/) then visit your [profile](https://developers.lateral.io/developer) and click 'Show' next to where it says `Primary key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`.

### Use the API

Initialize `LateralRecommender` with your API key by running:

    api = LateralRecommender::API.new YOUR_API_KEY
    
To add a document to the API call:

	api.add document_id: 'document_id', text: 'document text'
	
Please be aware that if you don't send enough meaningful text the API will return an error. So please ensure there is at least 100 or so words in the document you're adding.

To get recommendations for a document, use `near_text`:

	api.near_text text: 'document text'
	
This returns an array of Hashes containing a `document_id` and `distance`. 

#### Querying our pre-populated data

If you don't want to insert your own documents to the API, you can query one of our pre-filled data sets:

* **[Movies](https://www.freebase.com/film/film?instances)** (experimental) - Movies listed on [Freebase](https://www.freebase.com/) with plots from [Wikipedia](https://en.wikipedia.org)
* **News** (experimental) - News from multiple outlets updated every 15 minutes
* **[arXiv](http://arxiv.org/)** - Academic papers in Physics, Mathematics, Computer Science, Quantitative Biology, Quantitative Finance and Statistics
* **[PubMed](http://www.ncbi.nlm.nih.gov/pubmed)** - Medical journals
* **[Wikipedia](https://en.wikipedia.org)** - General knowledge

To use these, simply initialize `LateralRecommender` with a second argument containing the corpus:

    api = LateralRecommender::API.new YOUR_API_KEY, 'news'
    
The available values are `movies`, `news`, `arxiv`, `pubmed` or `wikipedia`. We plan to add more in the near future.

Now you can query the API using `near_text` or `near_user` without the need for populating the API with your own content:

	api.near_text text: 'document text'
	
#### Managing users

A feature of the API is to be able to add a representation of a user. The user is able to have many documents and when querying the API for recommendations you can specify the user and each of these documents will be used to get recommendations for that user.

*Note: This is an experimental feature of the API*

To add a user:

	api.add_user 'user_id'
	
To add a document to that user:
	
	api.add_user_document 'user_id', 'document_id', 'document text'
	
You can do this as many times as you want to build a more complete picture of the user. Then, to query for recommendations for that user:

	api.near_user 'user_id'

The response will be the same format as a `near_text`.

## Contributing

1. Fork it ( https://github.com/lateral/recommender-gem/fork )
2. Create `spec/env_vars.rb` file containing  `ENV['API_KEY'] = 'YOUR_KEY'`
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
