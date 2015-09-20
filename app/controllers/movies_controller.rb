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
    shld_redirect = false
    if params[:sort] != nil
	set_sort_preference(false)
	session[:sort] = params[:sort]
    elsif session[:sort] != nil
	set_sort_preference(true)
	shld_redirect = true
    else
	@movies = Movie.all
    end
    hash = params[:ratings]
    if ( hash != nil ) && ( !hash.empty?() )
	set_ratings_filter(false)
	session[:ratings] = params[:ratings]
    elsif session[:ratings] != nil
	set_ratings_filter(true)
    end
    if shld_redirect
	flash.keep
	redirect_to movies_path :action => :index, :sort => session[:sort]
    end
  end

  def set_ratings_filter (from_session)
	@checked_ratings = {}
	hash = {}
	if from_session
		hash = session[:ratings]
	else
        	hash = params[:ratings]
	end
        
	hash.each_key { |rating|
                        @checked_ratings[rating] = true }
        list = []
        @movies.each { |movie|
                        if @checked_ratings[movie.rating] == true
                                list << movie
                        end
                     }
        @movies = list
  end	

  def set_sort_preference (from_session)
    sort_type = ""
    if from_session
	sort_type = session[:sort]
    else
	sort_type = params[:sort]
    end
    if sort_type == "title"
		@title_class = "hilite"
                @movies = Movie.order("title")
    elsif sort_type == "release_date"
                @release_date_class = "hilite"
                @movies = Movie.order("release_date")	
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
