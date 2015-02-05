require 'spec_helper'

describe LateralRecommender do
  describe 'API' do
    let(:api) { LateralRecommender::API.new ENV['API_KEY'] }
    let(:body) { File.read('spec/fixtures/article-body.txt') }

    it 'errors with invalid API key' do
      api = LateralRecommender::API.new 'no'
      VCR.use_cassette('invalid_key') do
        response = api.near_text 'test'
        expect(response[:error][:status_code]).to eq(401)
        expect(response[:error][:message]).to include('invalid subscription key')
      end
    end

    it 'adds a document' do
      VCR.use_cassette('add') do
        response = api.add document_id: 'doc_id', text: body
        expect(response['document_id']).to eq('doc_id')
        expect(response['text']).to include('Space exploration')
      end
    end

    it 'gets recommendations' do
      VCR.use_cassette('near_text') do
        response = api.near_text body
        expect(response.length).to eq(20)
        expect(response.first['document_id']).to eq('doc_id')
      end
    end

    it 'gets recommendations by ID' do
      VCR.use_cassette('near_id') do
        response = api.near_id 'doc_id'
        expect(response.length).to eq(20)
        expect(response.first['document_id']).to eq('doc_id')
      end
    end

    it 'gets recommendations from movies' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'movies'
      VCR.use_cassette('near_text_movies') do
        response = api.near_text body
        expect(response.length).to eq(19)
        expect(response.first['title']).to eq('First World')
      end
    end

    it 'gets recommendations from news' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'news'
      VCR.use_cassette('near_text_news') do
        response = api.near_text body
        expect(response.length).to be > 10 # This should be done better
        expect(response.first['title']).to include('The Space Missions and Events')
      end
    end

    it 'gets recommendations from wikipedia' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'wikipedia'
      VCR.use_cassette('near_text_wikipedia') do
        response = api.near_text body
        expect(response.length).to eq(10)
        expect(response.first['title']).to eq('Space exploration')
      end
    end

    it 'gets recommendations from pubmed' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'pubmed'
      VCR.use_cassette('near_text_pubmed') do
        response = api.near_text body
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('NASA and the search')
      end
    end

    it 'gets recommendations from arxiv' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'arxiv'
      VCR.use_cassette('near_text_arxiv') do
        response = api.near_text body
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('A Lunar L2-Farside')
      end
    end

    it 'adds a user' do
      VCR.use_cassette('add_user') do
        response = api.add_user('user_id')
        expect(response['id']).to eq('user_id')
      end
    end

    it 'adds a user document' do
      VCR.use_cassette('add_user_document') do
        response = api.add_user_document('user_id', 'doc_id', body)
        expect(response['id']).to eq('doc_id')
        expect(response['user_id']).to eq('user_id')
        expect(response['body']).to include('Space exploration')
      end
    end

    # TODO: Change this so there is a document ID to validate
    it 'gets recommendations for a user' do
      VCR.use_cassette('near_user') do
        response = api.near_user('user_id')
        expect(response).to be_a(Array)
        expect(response.length).to be > 10
      end
    end

    it 'gets recommendations for a user from movies' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'movies'
      VCR.use_cassette('near_user_movies') do
        response = api.near_user('user_id')
        expect(response.length).to eq(19)
        expect(response.first['title']).to include('First World')
      end
    end

    it 'gets recommendations for a user from news' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'news'
      VCR.use_cassette('near_user_news') do
        response = api.near_user('user_id')
        expect(response.length).to be > 10 # This should be done better
        expect(response.first['title']).to include('The Space Missions and')
      end
    end

    it 'gets recommendations for a user from wikipedia' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'wikipedia'
      VCR.use_cassette('near_user_wikipedia') do
        response = api.near_user('user_id')
        expect(response.length).to eq(9) # First one is cut because it is same page
        expect(response.first['title']).to include('Unmanned NASA missions')
      end
    end

    it 'gets recommendations for a user from pubmed' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'pubmed'
      VCR.use_cassette('near_user_pubmed') do
        response = api.near_user('user_id')
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('NASA and the search for')
      end
    end

    it 'gets recommendations for a user from arxiv' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'arxiv'
      VCR.use_cassette('near_user_arxiv') do
        response = api.near_user('user_id')
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('A Lunar L2-Farside')
      end
    end

  end
end
