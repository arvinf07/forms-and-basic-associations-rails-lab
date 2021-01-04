class SongsController < ApplicationController
  def index
    @songs = Song.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)
    unless empty_notes?
      create_notes
    end

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :genre_id, :artist_name)
  end

  def empty_notes?
    params[:song][:notes].all? {|w| w.empty? }
  end  

  def create_notes
    notes = params[:song][:notes]
    notes.map do |note|
      Note.create(content: note, song_id: @song.id) unless note.blank?
      byebug
    end  
  end  

end

