class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  require 'jalali_date'
  before_filter :authenticate_user!, :except => [:after_sign_in_path_for,:after_inactive_sign_up_path_for,     :after_sign_up_path_for]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
  end


  def manage_uploads(item)
    if !params[:attachments].blank?
      @upload_ids = params[:attachments].split(',')
      for upload_id in @upload_ids
        if !upload_id.blank?
          @upload = Upload.find_by_id(upload_id)
          if !@upload.blank?
            @upload.uploadable_id = item.id
            @upload.save
          end
        end
      end
    end
  end

  def grant_access(ward, user)
    @flag = 0
    if user.assignments.blank?
      return false
    end
    if user.current_role_id.blank?
      return false
    else
      @ac = AccessControl.where(role_id: user.current_role_id).first
      @flag = @ac["#{ward}"] && 1 || 0
    end

    if @flag == 0
      return false
    else
      return true
    end
  end

  def owner(item, user)
    if item.user_id == user.id
      return true
    else
      return false
    end
  end

  def update_profile(params)
    @profile = current_user.profile
    @profile.phone_number = params[:phone_number]
    @profile.telegram_channel = params[:telegram_channel]
    @profile.instagram_page = params[:instagram_page]
    @profile.email = params[:email]
    @profile.mobile = params[:mobile]
    @profile.website = params[:website]
    @profile.address = params[:address]
    @profile.province_id = params[:province_id]
    @profile.city = params[:city]
    @profile.save
  end

end
