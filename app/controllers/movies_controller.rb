class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     
    @movies = Movie.all
    @all_ratings = Movie.ratings 
    
    @sort = params[:sort] || session[:sort]
    @ratings = params[:ratings] || session[:ratings]
    
    if !@sort.nil?
      @movies = @movies.order(@sort)
    end
    
    if !@ratings.nil?
      if !@ratings.kind_of?(Array) 
        @ratings = @ratings.keys 
      end
      @movies = @movies.where({rating: @ratings}) 
    else 
      #when uncheck all the boxes
      @ratings = Movie.ratings
    end
    
    session[:sort] = @sort
    session[:ratings] = @ratings
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
