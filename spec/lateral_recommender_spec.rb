require 'spec_helper'

describe LateralRecommender do
  describe 'API' do
    let(:api) { LateralRecommender::API.new ENV['API_KEY'] }
    let(:body) { File.read('spec/fixtures/article-body.txt') }

    it 'errors with invalid API key' do
      api = LateralRecommender::API.new 'no'
      VCR.use_cassette('invalid_key') do
        response = api.recommend_by_text 'test'
        expect(response[:error][:status_code]).to eq(403)
        expect(response[:error][:message]).to include('credentials are invalid')
      end
    end

    it 'adds a document' do
      VCR.use_cassette('add') do
        response = api.add document_id: 'doc_id', text: body
        expect(response['document_id']).to eq('doc_id')
        expect(response['text']).to include('Space exploration')
      end
    end

    it 'gets recommendations from text' do
      VCR.use_cassette('recommend_by_text') do
        response = api.recommend_by_text body
        expect(response.length).to eq(1)
        expect(response.first['document_id']).to eq('doc_id')
      end
    end

    it 'gets recommendations by ID' do
      VCR.use_cassette('recommend_by_id') do
        response = api.recommend_by_id 'doc_id'
        expect(response.length).to eq(1)
        expect(response.first['document_id']).to eq('doc_id')
      end
    end

    it 'gets recommendations by text in SEC' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'sec'
      VCR.use_cassette('recommend_by_text_sec') do
        response = api.recommend_by_text body, collections: '["item1a"]'
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('DIGITALGLOBE, INC._2014_10')
      end
    end

    it 'gets recommendations by ID in SEC' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'sec'
      VCR.use_cassette('recommend_by_id_sec') do
        id = 'SEC_item_1A-http://www.sec.gov/Archives/edgar/data/1099369/0001062993-14-006877.txt_item_1A'
        response = api.recommend_by_id id, collections: '["item1a"]'
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('DESTINY MEDIA TECHNOLOGIES')
      end
    end

    it 'gets recommendations by text in news' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'news'
      VCR.use_cassette('recommend_by_text_news') do
        response = api.recommend_by_text body
        expect(response.length).to be > 10 # This should be done better
        expect(response.first['title']).to include('NASA announces details of ')
      end
    end

    it 'gets recommendations from ID in news' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'news'
      VCR.use_cassette('recommend_by_id_news') do
        response = api.recommend_by_id '3076491'
        expect(response.length).to be > 10 # This should be done better
        expect(response.first['title']).to include('Goodbye MongoDB, Hello Pos')
      end
    end

    it 'gets recommendations by text in wikipedia' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'wikipedia'
      VCR.use_cassette('recommend_by_text_wikipedia') do
        response = api.recommend_by_text body
        expect(response.length).to eq(10)
        expect(response.first['title']).to eq('Space exploration')
      end
    end

    it 'gets recommendations by ID in wikipedia' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'wikipedia'
      VCR.use_cassette('recommend_by_id_wikipedia') do
        response = api.recommend_by_id 'wikipedia-11589297'
        expect(response.length).to eq(10)
        expect(response.first['title']).to eq('Manned mission to Mars')
      end
    end

    it 'gets recommendations by text in pubmed' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'pubmed'
      VCR.use_cassette('recommend_by_text_pubmed') do
        response = api.recommend_by_text body
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('NASA and the search')
      end
    end

    # it 'gets recommendations by ID in pubmed' do
    #   api = LateralRecommender::API.new ENV['API_KEY'], 'pubmed'
    #   VCR.use_cassette('recommend_by_id_pubmed') do
    #     response = api.recommend_by_id 'pubmed-15881781-1'
    #     expect(response.length).to eq(10)
    #     expect(response.first['title']).to include('NASA and the search')
    #   end
    # end

    it 'gets recommendations by text in arxiv' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'arxiv'
      VCR.use_cassette('recommend_by_text_arxiv') do
        response = api.recommend_by_text body
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('A Lunar L2-Farside')
      end
    end

    it 'gets recommendations by ID in arxiv' do
      api = LateralRecommender::API.new ENV['API_KEY'], 'arxiv'
      VCR.use_cassette('recommend_by_id_arxiv') do
        response = api.recommend_by_id 'arxiv-http://arxiv.org/abs/1403.2165'
        expect(response.length).to eq(10)
        expect(response.first['title']).to include('Set-valued sorting index')
      end
    end
  end
end
