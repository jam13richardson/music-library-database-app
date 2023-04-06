require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  def reset_albums_table
    seed_sql = File.read("spec/seeds/albums_seeds.sql")
    connection = PG.connect({ host: "127.0.0.1", dbname: "music_library_test" })
    connection.exec(seed_sql)
  end

xcontext 'GET /albums' do 
  it 'should return the list of albums' do
    response = get('/albums')

    expected_response = 'Doolittle, Surfer Rosa, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

    expect(response.status).to eq(200)
    expect(response.body).to eq(expected_response)
end
end

 context "GET /artists" do
    it "returns a list of artist names" do
      response = get("/artists")
      expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos"
      expect(response.body).to eq(expected_response)
    end
  end

context 'POST /albums' do
  it 'should vreate a new album' do
    response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

    expect(response.status).to eq(200)
    expect(response.body).to eq('')
  end 
end

context "POST /artists" do
    it "creates a new artist" do
      response = post("/artists", name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq 200
      expect(response.body).to eq("")
      response_2 = get("/artists")
      expect(response_2.body).to include "Wild Nothing"
    end
  end

end
