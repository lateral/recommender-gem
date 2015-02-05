require 'lateral_recommender/version'
require 'httpclient'
require 'active_support/core_ext/hash'
require 'json'

module LateralRecommender
  class API
    # @param [String] key The Lateral API key
    # @param [String] corpora The corpora to recommend from e.g. movies, news, wikipedia, arxiv or pubmed
    def initialize(key, corpora = 'recommender')
      @corpora = %w(movies news wikipedia arxiv pubmed).include?(corpora) ? "collections/#{corpora}" : corpora
      @uri = 'https://api.lateral.io/'
      @key = key
      @client = HTTPClient.new
    end

    # Add a document to the recommender
    #
    # @param [Hash] params The fields of the document.
    # @option params [String] :document_id A unique identifier for the document (required)
    # @option params [String] :text The body of the document (required)
    # @option params [String] :meta A JSON object containing any metadata
    # @return [Hash] the document object that was added.
    def add(params)
      post "#{@corpora}/add", params.stringify_keys
    end

    # Get recommendations for the provided text
    #
    # @param [String] text The text to get recommendations for.
    # @param [Hash] opts Additional options for the request.
    # @option opts [Integer] :results (20) How many results to return
    # @option opts [Array] :select_from An array of IDs to return results from
    # @return [Array] An array of Hashes containing the recommendations
    def near_text(text, opts = {})
      post "#{@corpora}/recommend", { text: text }.merge(opts)
    end

    # Get recommendations for the provided id
    #
    # @param [String] text The ID of the document to get recommendations for.
    # @param [Hash] opts Additional options for the request.
    # @option opts [Integer] :results (20) How many results to return
    # @option opts [Array] :select_from An array of IDs to return results from
    # @return [Array] An array of Hashes containing the recommendations
    def near_id(id, opts = {})
      post "#{@corpora}/recommend", { document_id: id }.merge(opts)
    end

    # Get recommendations for the provided text
    #
    # @param [String] id The ID of the user to return recommendations for
    # @param [Hash] opts Additional options for the request.
    # @option opts [Integer] :results (20) How many results to return
    # @option opts [Array] :select_from An array of IDs to return results from
    # @return [Array] An array of Hashes containing the recommendations
    def near_user(id, opts = {})
      if @corpora != 'recommender'
        opts = opts.merge corpus: @corpora.gsub('collections/', '')
      end
      post 'personalisation/recommend', { user_id: id }.merge(opts)
    end

    # Get all users
    #
    # @return [Array] An array of all user Hashes
    def users
      get 'personalisation/users'
    end

    # Get one user
    #
    # @param [String] id The ID of the user to return
    # @return [Hash] A user Hash
    def get_user(id)
      get 'personalisation/users', id: id
    end

    # Add a user
    #
    # @param [String] id The ID of the user to add
    # @return [Hash] The user Hash
    def add_user(id)
      post 'personalisation/users', id: id
    end

    # Delete a user
    #
    # @param [String] id The ID of the user to add
    # @return [Hash] The user Hash
    def delete_user(id)
      delete 'personalisation/users', id: id
    end

    # Get all user documents
    #
    # @return [Array] An array of all document Hashes
    def user_documents
      get 'personalisation/documents'
    end

    # Get all user documents for a specified user
    #
    # @param [String] user_id The ID of the user
    # @return [Array] An array of document Hashes that belong to the user
    def user_documents(user_id)
      get 'personalisation/documents/by-user', user_id: user_id
    end

    # Get one document that belongs to a specified user
    #
    # @param [String] user_id The ID of the user
    # @param [String] document_id The ID of the document
    # @return [Hash] An document Hash
    def user_document(user_id, document_id)
      get 'personalisation/documents/by-id', user_id: user_id, id: document_id
    end

    # Add a document to a user
    #
    # @param [String] user_id The ID of the user
    # @param [String] document_id The ID of the document
    # @param [String] body The contents of the document
    # @return [Hash] The documents Hash
    def add_user_document(user_id, document_id, body, opts = {})
      post 'personalisation/documents', { user_id: user_id, id: document_id, body: body }.merge(opts)
    end

    # Delete a users document
    #
    # @param [String] user_id The ID of the user
    # @param [String] document_id The ID of the document
    # @return [Hash] The documents Hash
    def delete_user_document(user_id, document_id)
      delete 'personalisation/documents', user_id: user_id, id: document_id
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

    def req(request)
      return { error: error(request) } if request.status != 200 && request.status != 201
      JSON.parse(request.body)
    end

    def error(request)
      begin
        message = JSON.parse(request.body)['message']
      rescue
        message = request.header.reason_phrase
      end
      return { status_code: request.status } unless message
      { status_code: request.status, message: message }
    end

    def url(path)
      "#{@uri}#{path}/?subscription-key=#{@key}"
    end

    def post(path, params)
      req @client.post url(path), params.stringify_keys
    end

    def get(path, params)
      req @client.get url(path), params.stringify_keys
    end
  end
end

