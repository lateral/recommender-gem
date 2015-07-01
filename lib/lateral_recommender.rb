require 'lateral_recommender/version'
require 'erb'
require 'httparty'
require 'json'

module LateralRecommender
  class API
    JSON_HEADERS = { 'Content-Type' => 'application/json' }
    EXTERNAL_CORPORA = %w(arxiv news pubmed sec wikipedia bloomberg-public)

    # @param [String] key The Lateral API key
    # @param [String] corpus The corpora to recommend from e.g. arxiv, sec, pubmed, wikipedia, news, bloomberg-public
    def initialize(key, corpus = 'recommender')
      @corpus = EXTERNAL_CORPORA.include?(corpus) ? corpus : 'recommender'
      @endpoint = "https://#{@corpus}-api.lateral.io/"
      @key = key
    end

    # Add a document to the recommender
    #
    # @param [Hash] params The fields of the document.
    # @option params [String] :document_id A unique identifier for the document (required)
    # @option params [String] :text The body of the document (required)
    # @option params [String] :meta A JSON object containing any metadata
    # @return [Hash] the document object that was added.
    def add(params)
      post 'add', params
    end

    # Get recommendations for the provided text
    #
    # @param [String] text The text to get recommendations for.
    # @param [Hash] opts Additional options for the request.
    # @option opts [Integer] :results (20) How many results to return
    # @option opts [Array] :select_from An array of IDs to return results from
    # @return [Array] An array of Hashes containing the recommendations
    def recommend_by_text(text, opts = {})
      post 'recommend-by-text', { text: text }.merge(opts)
    end

    # Get recommendations for the provided id
    #
    # @param [String] id The ID of the document to get recommendations for.
    # @param [Hash] opts Additional options for the request.
    # @option opts [Integer] :results (20) How many results to return
    # @option opts [Array] :select_from An array of IDs to return results from
    # @return [Array] An array of Hashes containing the recommendations
    def recommend_by_id(id, opts = {})
      post 'recommend-by-id', { document_id: id }.merge(opts)
    end

    # Takes two result arrays and using the specified key merges the two
    #
    # @param [Array] mind_results The results from the API
    # @param [Array] database_results The results from the database
    # @param [String] key The key of the database_results Hash that should match the mind_results id key
    # @return [Hash] An array of merged Hashes
    def match_documents(mind_results, database_results, key = 'id')
      return [] unless database_results
      mind_results.each_with_object([]) do |result, arr|
        next unless (doc = database_results.find { |s| s[key].to_s == result['document_id'].to_s })
        arr << doc.attributes.merge(result)
      end
    end

    private

    def parse_request(request)
      return { error: error(request) } if request.code != 200 && request.code != 201
      JSON.parse(request.body)
    end

    def error(request)
      { status_code: request.code, message: JSON.parse(request.body)['message'] }
    rescue JSON::ParserError
      { status_code: request.code }
    end

    def url(path)
      "#{@endpoint}#{path}/?subscription-key=#{@key}"
    end

    def post(path, params)
      return parse_request request 'post', path, params if @corpus == 'recommender'
      parse_request request_json 'post', path, params.merge(collection: [@corpus])
    end

    def get(path, params)
      return parse_request request 'get', path, params if @corpus == 'recommender'
      parse_request request_json 'get', path, params.merge(collection: [@corpus])
    end

    def request(method, path, params)
      HTTParty.send method, url(path), body: params
    end

    def request_json(method, path, params)
      HTTParty.send method, url(path), body: params.to_json, headers: JSON_HEADERS
    end
  end
end
