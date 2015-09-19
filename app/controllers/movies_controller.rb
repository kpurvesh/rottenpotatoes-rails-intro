class MoviesController < ApplicationController

  def initialize
   super();
   @all_ratings = Movie.get_all_ratings()
   @checked_ratings = {}
   @all_ratings.each {|rating| @checked_ratings[rating] = true }
  end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @title_class = ""
    @release_date_class = ""
    if params[:ratings] != nil
	@checked_ratings = {}
	hash = params[:ratings]
	list = []
	hash.each_key { |rating| 
			@checked_ratings[rating] = true 
			list.concat(Movie.where(:rating => rating)) }
	@movies = list
    else
    	if params[:sort] == "title"
		@title_class = "hilite"
		@movies = Movie.order("title")
	    elsif params[:sort] == "release_date"
		@release_date_class = "hilite"
		@movies = Movie.order("release_date")
    	else
    		@movies = Movie.all
    	end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
