# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get "/artists" do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:all_artists)
  end

  get '/albums' do 
    repo = AlbumRepository.new
    albums = repo.all 
    response = albums.map do |album|
    album.title.split(', ')
  end
  return response 
  end

  # get "/artists" do
  #   repo = ArtistRepository.new
  #   artists = repo.all
  #   response = artists.map { |artist| artist.name }.join(", ")
  #   return response
  # end

  # get "/artists/:id" do
  #   repo = ArtistRepository.new
  #   artist_id = params[:id]
  #   @returned_artist = repo.find(artist_id)
  #   return erb(:artists)
  # end
  
  get "/albums/:id" do
    repo = AlbumRepository.new
    repo2 = ArtistRepository.new
    album_id = params[:id]
    @returned_album = repo.find(album_id)
    @returned_artist = repo2.find(@returned_album.artist_id)
    return erb(:albums)
  end

  get "/albums" do
    repo = AlbumRepository.new
    @albums = repo.all
    return erb(:index)
  end

  post '/albums' do 
    repo = AlbumRepository.new
    new_album = Album.new
    new_album.title = params[:title]
    new_album.release_year = params[:release_year]
    new_album.artist_id = params[:artist_id]

    repo.create(new_album)

    return ''
  end 

post "/artists" do
    repo = ArtistRepository.new
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo.create(artist)
    return ""
  end

  get "/albums/new" do
    return erb(:new_album_form)
  end

  post "/albums" do
    if invalid_album_request_parameters?
      status 400
      return ''
    else
    title = params[:title]
    release_year = params[:release_year]
    artist_id = params[:artist_id]
    new_album = Album.new
    new_album.title = title
    new_album.release_year = release_year
    new_album.artist_id = artist_id
    AlbumRepository.new.create(new_album)
    return erb(:new_album_created)
    end
  end

  get "/albums/:id" do
    repo = AlbumRepository.new
    repo2 = ArtistRepository.new
    album_id = params[:id]
    @returned_album = repo.find(album_id)
    @returned_artist = repo2.find(@returned_album.artist_id)
    return erb(:albums_html)
  end

  get "/artists/new" do
    return erb(:new_artist_form)
  end
  
  post "/artists" do
      if invalid_artist_request_parameters?
        status 400
        return ''
      else
      name = params[:name]
      genre = params[:genre]
      new_artist = Artist.new
      new_artist.name = name
      new_artist.genre = genre
      ArtistRepository.new.create(new_artist)
      return erb(:new_artist_created)
      end
    end

  get "/artists/:id" do
    repo = ArtistRepository.new
    artist_id = params[:id]
    @returned_artist = repo.find(artist_id)
    return erb(:artists)
  end


end


