class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:advertisements, :login, :sign_up, :advertisement, :make_advertisement, :upload]
  before_action :is_admin, only: [:make_advertisement]

  def advertisements
    @advertisements = Advertisement.all
    @result = []
    for advertisement in @advertisements
      @result << {id: advertisement.id, title: advertisement.title, 'cover' => request.base_url + advertisement.cover('large')}
    end
    render :json => @result.to_json, :callback => params['callback']
  end

  def login
    if User.find_by_username(params['username']).try(:valid_password?, params[:password])
      @user = User.find_by_username(params['username'])
      render :json => {result: 'OK', token: JWTWrapper.encode({ user_id: @user.id })}.to_json , :callback => params['callback']
    else
      render :json => {result: 'ERROR',  error: @user.errors }.to_json , :callback => params['callback']
    end
  end


  def sign_up
    @user = User.new(username: params['username'], mobile: params['username'], password: params['password'], password_confirmation: params['password_confirmation'])
    if @user.save
      @profile = Profile.create(user_id: @user.id, name: params[:name])
      render :json => {result: 'OK', token: JWTWrapper.encode({ user_id: @user.id })}.to_json, :callback => params['callback']
    else
      render :json => {result: 'ERROR', error: @user.errors }.to_json , :callback => params['callback']
    end
  end

  def advertisement
    @advertisement = Advertisement.find(params[:id])
    @photos = []
    for photo in @advertisement.photos('large')
      @photos << {url:  request.base_url + photo[:url], id: photo[:id]}
    end
    @result = {id: @advertisement.id, title: @advertisement.title, content: @advertisement.content,'cover' => request.base_url + @advertisement.cover('large'), photos: @photos}
    render :json => @result.to_json, :callback => params['callback']
  end

  def make_advertisement
    @advertisement = Advertisement.create(title: params[:title])
    for upload_id in params[:uploaded]
      @upload = Upload.find_by_id(upload_id)
      if !@upload.blank?
        @upload.uploadable_id = @advertisement.id
        @upload.save
      end
    end
    @result = {id: @advertisement.id}
    render :json => @result.to_json, :callback => params['callback']
  end

  def upload
    @upload = Upload.new
    @upload.uploadable_type = params[:uploadable_type]
    @upload.uploadable_id = params[:uploadable_id]
    @upload.attachment_type = params[:attachment_type]
    @upload.attachment = params[:file]
    if @upload.save
      render :json => {result: 'OK', id: @upload.id }.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def is_admin
    if current_user.blank?
      head(403)
    end
  end

end
