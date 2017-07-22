class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json 

  def index 
    if params[:tags]
      @results = Location.joins(:tags).where(:tags => { :name => params[:tags] }).having("count(tags.name) = ?", params[:tags].count).group('locations.id')
      # @results = Location.tagged_with(params[:tags])
      @locations = Location.all
      @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.infowindow render_to_string(partial: "locations/infowindow", locals: { location: location })
        marker.picture({
          :url => "http://icons.iconarchive.com/icons/paomedia/small-n-flat/48/map-marker-icon.png",
          :width   => 48,
          :height  => 48,
        })
        marker.json({ 
          sidebar: render_to_string(partial: "/locations/sidebar", locals: { location: location }) 
        })
        # byebug
  
      end
    else
      @locations = Location.all
      @hash = Gmaps4rails.build_markers(@locations) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.infowindow render_to_string(partial: "locations/infowindow", locals: { location: location })
        marker.picture({
          :url => "http://icons.iconarchive.com/icons/paomedia/small-n-flat/48/map-marker-icon.png",
          :width   => 48,
          :height  => 48,
        })
        marker.json({ 
          sidebar: render_to_string(partial: "/locations/sidebar", locals: { location: location }) 
        })
        # byebug
  
      end
    end
  end 

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:name, :description, :latitude, :longitude, :all_tags)
    end
end
