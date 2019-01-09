class AdvertisementsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy, :check, :change_rank, :change_status, :change_size]

  def change_status
    if params[:status] == "1"
      @advertisement.status = 1
    else
      @advertisement.status = 0
    end
    @advertisement.save
  end

  def change_size
    if params[:size] == "2"
      @advertisement.size = 2
    else
      @advertisement.size = 1
    end
    @advertisement.save
  end

  def change_rank
    if params[:move] == 'up'
      @advertisement.rank += 1
    else
      @advertisement.rank -= 1
    end
    @advertisement.save
    redirect_to '/'
  end

  def check
    if params[:to] == 'check'
      @advertisement.view_in_homepage = true
    else
      @advertisement.view_in_homepage = false
    end
    @advertisement.save
  end

  # GET /advertisements
  # GET /advertisements.json
  def index
    if !params[:category_id].blank?
      @major_ads = Advertisement.where(status:1, size: 2, category_id:  params[:category_id]).order('rank desc').limit(6)
      @minor_ads = Advertisement.where(status:1, size: 1, category_id:  params[:category_id]).order('created_at desc')
    else
      @major_ads = Advertisement.where(status:1, size: 2).order('rank desc').limit(6)
      @minor_ads = Advertisement.where(status:1, size: 1).order('created_at desc')
    end
  end

  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
  end

  # GET /advertisements/new
  def new
    @advertisement = Advertisement.new
  end

  # GET /advertisements/1/edit
  def edit
    @upload_ids = Upload.where(uploadable_type: 'Advertisement', uploadable_id: @advertisement.id).pluck(:id)
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = Advertisement.new(advertisement_params)
    @advertisement.size = 1
    @advertisement.status = 0
    @advertisement.user_id = current_user.id
    respond_to do |format|
      if @advertisement.save
        manage_uploads(@advertisement)
        format.html { redirect_to @advertisement, notice: 'advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        @advertisement.user_id = current_user.id
        manage_uploads(@advertisement)
        format.html { redirect_to @advertisement, notice: 'advertisement was successfully updated.' }
        format.json { render :show, status: :ok, location: @advertisement }
      else
        format.html { render :edit }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisements/1
  # DELETE /advertisements/1.json
  def destroy
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to advertisements_url, notice: 'advertisement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advertisement_params
    params.require(:advertisement).permit(:title, :content, :agency_id, :uuid, :category_id)
  end
end
