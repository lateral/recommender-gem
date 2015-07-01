require 'spec_helper'

describe LateralRecommender do

  # Clear the test key first
  HTTParty.post "https://recommender-api.lateral.io/delete-all/?subscription-key=#{ENV['API_KEY']}"

  describe 'API' do
    let(:api) { LateralRecommender::API.new ENV['API_KEY'] }
    let(:body) { File.read('spec/fixtures/article-body.txt') }

    it 'errors with invalid API key' do
      api = LateralRecommender::API.new 'no'
      response = api.recommend_by_text 'test'
      expect(response[:error][:status_code]).to eq(403)
      expect(response[:error][:message]).to include('Invalid authentication credentials')
    end

    it 'adds a document' do
      response = api.add document_id: 'doc_id', text: body
      expect(response['document_id']).to eq('doc_id')
      expect(response['text']).to include('Space exploration')
    end

    it 'gets recommendations from text' do
      response = api.recommend_by_text body
      expect(response.length).to eq(1)
      expect(response.first['document_id']).to eq('doc_id')
    end

    it 'gets recommendations by ID' do
      response = api.recommend_by_id 'doc_id'
      expect(response.length).to eq(1)
      expect(response.first['document_id']).to eq('doc_id')
    end

    it 'gets recommendations by text in SEC' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'sec'
      response = api.recommend_by_text body, collections: %w(item1a)
      expect(response.length).to eq(10)
      expect(response.first['title']).to include('DIGITALGLOBE, INC._2014_10')
    end

    it 'gets recommendations by ID in SEC' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'sec'
      id = 'SEC_item_1A-http://www.sec.gov/Archives/edgar/data/1099369/0001062993-14-006877.txt_item_1A'
      response = api.recommend_by_id id, collections: %w(item1a)
      expect(response.length).to eq(10)
      expect(response.first['title']).to include('DESTINY MEDIA TECHNOLOGIES')
    end

    it 'gets recommendations by text in news' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'news'
      response = api.recommend_by_text body
      expect(response.length).to be > 10 # This should be done better
      expect(response.first['title']).to include('NASA Announces Next Steps ')
    end

    it 'gets recommendations from ID in news' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'news'
      response = api.recommend_by_id '3076491'
      expect(response.length).to be > 10 # This should be done better
      expect(response.first['title']).to include('Tree structure query with ')
    end

    it 'gets recommendations by text in wikipedia' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'wikipedia'
      response = api.recommend_by_text body
      expect(response.length).to eq(10)
      expect(response.first['title']).to eq('Space exploration')
    end

    it 'gets recommendations by ID in wikipedia' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'wikipedia'
      response = api.recommend_by_id 'wikipedia-11589297'
      expect(response.length).to eq(10)
      expect(response.first['title']).to eq('Manned mission to Mars')
    end

    it 'gets recommendations by text in pubmed' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'pubmed'
      response = api.recommend_by_text body
      expect(response.length).to eq(10)
      expect(response.first['title']).to include('NASA and the search')
    end

    it 'gets recommendations by ID in pubmed' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'pubmed'
      response = api.recommend_by_id 'pubmed-15881781-1'
      expect(response.length).to eq(10)
      expect(response.first['title']).to include('Radiation analysis ')
    end

    it 'gets recommendations by text in arxiv' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'arxiv'
      response = api.recommend_by_text body
      expect(response.length).to eq(10)
      expect(response.first['title']).to include('A Lunar L2-Farside')
    end

    it 'gets recommendations by ID in arxiv' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'arxiv'
      response = api.recommend_by_id 'arxiv-http://arxiv.org/abs/1403.2165'
      expect(response.length).to eq(10)
      expect(response.first['title']).to include('Set-valued sorting index')
    end
  end
end
