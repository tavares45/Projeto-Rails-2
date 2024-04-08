class MoviesController < ApplicationController
  
  require 'csv'
  require 'byebug'
  require 'securerandom'
  require 'uuidtools'

  skip_before_action :verify_authenticity_token, only: [:import_csv]

  def index
    @movies = Movie.order(year: :asc)

    @movies = @movies.where(year: params[:year]) if params[:year].present?
    @movies = @movies.where(genre: params[:genre]) if params[:genre].present?
    @movies = @movies.where(country: params[:country]) if params[:country].present?
    #@movies = @movies.group_by(&:title).values.map(&:first)

    response_data = []

    @movies.each do |movie|
      response_data << {
        id: movie.id,
        title: movie.title,
        genre: movie.genre,
        year: movie.year,
        country: movie.country,
        published_at: movie.published_at.strftime('%Y-%d-%m'),
        description: movie.description
      }
    end

    render json: response_data
  end

  def show
  end

  def import_csv
    csv_text = params['file'].tempfile.read
    csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')
  
    imported_data = []
  
    csv.each do |row|
      movie = Movie.new(
        id: SecureRandom.uuid,
        title: row['title'],
        genre: row['type'],
        year: row['release_year'],
        country: row['country'],
        published_at: row['date_added'],
        description: row['description']
      )

      if movie.save
        imported_data << {  
          id: movie.id,
          title: movie.title,
          genre: movie.genre,
          year: movie.year, 
          country: movie.country,
          published_at: movie.published_at,
          description: movie.description
        }
      end
    end

    render json: imported_data
  end
end 
  




  
  
