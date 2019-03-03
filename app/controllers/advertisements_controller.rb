class AdvertisementsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_action :set_advertisement, only: [:show, :edit, :update, :destroy, :check, :change_rank, :change_status, :change_size]
  before_action :check_user, only: [:new, :edit, :update, :destroy, :create]
  before_action :verify_ads, only: [:change_status, :change_size, :check]

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
    if !grant_access("ability_to_verify_ads", current_user)
      head(403)
    else
      if params[:move] == 'up'
        @advertisement.rank += 1
      else
        @advertisement.rank -= 1
      end
      @advertisement.save
      redirect_to '/'
    end
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
    if !owner(@advertisement, current_user)
      head(403)
    end
    @upload_ids = Upload.where(uploadable_type: 'Advertisement', uploadable_id: @advertisement.id).pluck(:id)
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = Advertisement.new(advertisement_params)
    @advertisement.size = 1
    @advertisement.status = 0
    @advertisement.user_id = current_user.id
    set_category
    update_ad_contact(params)
    respond_to do |format|
      if @advertisement.save
        update_profile(params)
        manage_uploads(@advertisement)
        format.html { redirect_to @advertisement, notice: 'advertisement was successfully created.' }
        format.json { render :show, status: :created, location: @advertisement }
      else
        format.html { render :new }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end


  def update_ad_contact(params)
    @advertisement.phone_number = params[:phone_number]
    @advertisement.telegram_channel = params[:telegram_channel]
    @advertisement.instagram_page = params[:instagram_page]
    @advertisement.email = params[:email]
    @advertisement.address = params[:address]
    @advertisement.website = params[:website]
    @advertisement.city = params[:city]
    @advertisement.province_id = params[:province_id]
    @advertisement.mobile = params[:mobile]
  end

  # PATCH/PUT /advertisements/1
  # PATCH/PUT /advertisements/1.json
  def update
    if !owner(@advertisement, current_user)
      head(403)
    end
    set_category
    update_ad_contact(params)
    respond_to do |format|
      if @advertisement.update(advertisement_params)
        @advertisement.user_id = current_user.id
        manage_uploads(@advertisement)
        update_profile(params)
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
    if !owner(@advertisement, current_user)
      head(403)
    end
    @advertisement.destroy
    respond_to do |format|
      format.html { redirect_to advertisements_url, notice: 'advertisement was successfully destroyed.' }
      format.json { head :no_content }
      format.js
    end
  end

  def set_category
    @category = Category.find_by_uuid(params[:subsubcategory])
    @advertisement.category_id = @category.id
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_advertisement
    @advertisement = Advertisement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advertisement_params
    params.require(:advertisement).permit(:title, :content, :agency_id, :uuid, :category_id, :phone_number, :city, :address, :email, :telegram_channel,:instagram_page, :website)
  end

  def verify_ads
    if !grant_access("ability_to_verify_ads", current_user)
      head(403)
    end
  end

  def check_user
    if !grant_access("ability_to_post_ads", current_user)
      head(403)
    end
  end
end
