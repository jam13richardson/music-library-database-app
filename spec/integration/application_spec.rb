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

#old test - 
# context 'GET /albums' do 
#   it 'should return the list of albums' do
#     response = get('/albums')

#     expected_response = 'Doolittle, Surfer Rosa, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring'

#     expect(response.status).to eq(200)
#     expect(response.body).to eq(expected_response)
# end
# end

#old test - 
#  context "GET /artists" do
#     it "returns a list of artist names" do
#       response = get("/artists")
#       expected_response = "Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos"
#       expect(response.body).to eq(expected_response)
#     end
#   end


context 'POST /albums' do
  it 'should vreate a new album' do
    response = post('/albums', title: 'OK Computer', release_year: '1997', artist_id: '1')

    expect(response.status).to eq(200)
    expect(response.body).to eq('')
  end 
end

context "get /albums/new" do
  it "returns the view with the html form" do
    response = get("/albums/new")
    expect(response.status).to eq 200
    expect(response.body).to include '<form action="/albums" method="POST">'
  end
end

context "post /albums" do
  it "returns a new filled form" do
    response = post("/albums", title: "Trompe le Monde", release_year: "1991", artist_id: "1")
    expect(response.status).to eq 200
    expect(response.body).to include('<h1>Your album has been added!</h1>')
  end
end

context 'GET /albums/:id' do
  it "returns info about album 1" do 
    response = get('/albums/1')

    expect(response.status).to eq(200)
    expect(response.body).to include('<h1>Doolittle</h1>')
    expect(response.body).to include('Release year: 1989')
    expect(response.body).to include('Artist: Pixies')
  end
end

  # context "GET /albums" do
  #   it "returns a list of album titles" do
  #     response = get("/albums")
  #     expect(response.status).to eq 200
  #     expect(response.body).to include '<div><br>Title: Doolittle<br>Release year: 1989<br></div>'
  #     expect(response.body).to include '<div><br>Title: Ring Ring<br>Release year: 1973<br></div>'
  #   end
  # end

context "POST /artists" do
    it "creates a new artist" do
      response = post("/artists", name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq 200
      expect(response.body).to eq("")
      response_2 = get("/artists")
      expect(response_2.body).to include "Wild Nothing"
    end
  end

  context "GET /albums" do
    it "returns a list of album titles with links" do
      response = get("/albums")
      expect(response.status).to eq 200
      expect(response.body).to include '<div><br>Title: <a href="/albums/1"> Doolittle</a><br>Release year: 1989<br></div>'
      expect(response.body).to include '<div><br>Title: <a href="/albums/12"> Ring Ring</a><br>Release year: 1973<br></div>'
    end
  end

  context "GET /artists" do
    it "returns single artist from its id in html" do
      response = get("/artists/1") 
      expect(response.status).to eq 200
      expect(response.body).to include('Name: Pixies<br>')
    end
  end

  context "GET /artists" do
    it "returns a list of artist names in html with links for each" do
      response = get("/artists")
      expect(response.body).to include '<div><br>Name: <a href="/artists/1"> Pixies</a><br>Genre: Rock<br></div>'
    end
  end

  context "get /artists/new" do
    it "returns the view with the html form" do
      response = get("/artists/new")
      expect(response.status).to eq 200
      expect(response.body).to include '<form action="/artists" method="POST">'
    end
  end

  context "post /artists" do
    it "returns a new filled form" do
      response = post("/artists", name: "Little flat", genre: "Swamp Rock")
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Your artist has been added!</h1>')
    end
  end

end
