class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:advertisements, :login, :sign_up, :advertisement]

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
      render :json => {result: 'ERROR' }.to_json , :callback => params['callback']
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

    def advertisement
      @advertisement = Advertisement.create(title: params[:title])
      @result = {id: @advertisement.id}
      render :json => @result.to_json, :callback => params['callback']
    end
end
