class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:advertisements, :login, :sign_up, :advertisement, :make_advertisement, :upload, :profile, :owner, :my_advertisements, :delete_advertisement, :delete_photo, :make_pin, :unpin, :pinned, :like, :dislike, :all_unseens]
  before_action :is_admin, only: [:make_advertisement, :profile, :owner, :my_advertisements, :delete_advertisement, :delete_photo]

  def advertisements
    if params[:q].blank?
      @advertisements = Advertisement.all.order('updated_at desc').paginate(:page => params[:page], :per_page => 10)
    else
      @advertisements = Advertisement.search params[:q], star: true
    end
    @result = []
    for advertisement in @advertisements
      @result << {id: advertisement.id, title: advertisement.title, content: advertisement.content ,'cover' => request.base_url + advertisement.cover('large')}
    end
    render :json => @result.to_json, :callback => params['callback']
  end

  def login
    if User.find_by_username(params['username']).try(:valid_password?, params[:password])
      @user = User.find_by_username(params['username'])
      render :json => {result: 'OK', token: JWTWrapper.encode({ user_id: @user.id })}.to_json , :callback => params['callback']
    else
      render :json => {result: 'ERROR',  error: I18n.t(:doesnt_match) }.to_json , :callback => params['callback']
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
    if current_user && current_user.id == @advertisement.user_id
      @owner = true
    else
      @owner = false
    end
    @result = {id: @advertisement.id, title: @advertisement.title, content: @advertisement.content, phone_number: @advertisement.phone_number, city: @advertisement.city, address: @advertisement.address, email: @advertisement.email, telegram_channel: @advertisement.telegram_channel, instagram_page: @advertisement.instagram_page, website: @advertisement.website,'cover' => request.base_url + @advertisement.cover('large'), photos: @photos, owner: @owner}
    render :json => @result.to_json, :callback => params['callback']
  end

  def make_advertisement
    @advertisement = Advertisement.create(title: params[:title], content: params[:content], user_id: current_user.id, phone_number: params[:phone_number], city: params[:city], address: params[:address], email: params[:email], telegram_channel: params[:telegram_channel], instagram_page: params[:instagram_page], website: params[:website])
    if !params[:uploaded].blank?
      for upload_id in params[:uploaded]
        @upload = Upload.find_by_id(upload_id)
        if !@upload.blank?
          @upload.uploadable_id = @advertisement.id
          @upload.save
        end
      end
    end
    @photos = []
    for photo in @advertisement.photos('large')
      @photos << {url:  request.base_url + photo[:url], id: photo[:id]}
    end
    @result = {id: @advertisement.id, title: @advertisement.title, content: @advertisement.content, phone_number: @advertisement.phone_number, 'cover' => request.base_url + @advertisement.cover('large'), photos: @photos}
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

  def profile
    @profile = current_user.profile
    render :json => @profile.to_json, :callback => params['callback']
  end

  def my_advertisements
    @advertisements = current_user.advertisements.order('updated_at desc')
    @result = []
    for advertisement in @advertisements
      @result << {id: advertisement.id, title: advertisement.title, content: advertisement.content ,'cover' => request.base_url + advertisement.cover('large')}
    end
    render :json => @result.to_json, :callback => params['callback']
  end

  def delete_advertisement
    @advertisement = current_user.advertisements.find(params[:id])
    if @advertisement.destroy
      @advertisements = current_user.advertisements.order('updated_at desc')
      @result = []
      for advertisement in @advertisements
        @result << {id: advertisement.id, title: advertisement.title, content: advertisement.content ,'cover' => request.base_url + advertisement.cover('large')}
      end
      render :json => @result.to_json, :callback => params['callback']
    else
      render :json => {error: 'ERROR'}.to_json , :callback => params['callback']
    end
  end

  def delete_photo
    @upload = Upload.find(params[:id])
    @advertisement = Advertisement.find(@upload.uploadable_id)
    if @advertisement.user_id == current_user.id
      @upload.destroy
      @photos = []
      for photo in @advertisement.photos('large')
        @photos << {url:  request.base_url + photo[:url], id: photo[:id]}
      end
      render :json => @photos.to_json, :callback => params['callback']
    else
      render :json => {error: 'ERROR'}.to_json , :callback => params['callback']
    end
  end



  def edit_advertisement
    @advertisement = Advertisement.find(params[:id])
    @advertisement.title = params[:title]
    @advertisement.content = params[:content]
    @advertisement.phone_number = params[:phone_number]
    @advertisement.city = params[:city]
    @advertisement.address = params[:address]
    @advertisement.email = params[:email]
    @advertisement.telegram_channel = params[:telegram_channel]
    @advertisement.instagram_page = params[:instagram_page]
    @advertisement.website = params[:website]
    @advertisement.save
    if !params[:uploaded].blank?
      for upload_id in params[:uploaded]
        @upload = Upload.find_by_id(upload_id)
        if !@upload.blank?
          @upload.uploadable_id = @advertisement.id
          @upload.save
        end
      end
    end
    @photos = []
    for photo in @advertisement.photos('large')
      @photos << {url:  request.base_url + photo[:url], id: photo[:id]}
    end
    @result = {id: @advertisement.id, title: @advertisement.title, content: @advertisement.content, phone_number: @advertisement.phone_number, 'cover' => request.base_url + @advertisement.cover('large'), photos: @photos}
    render :json => @result.to_json, :callback => params['callback']
  end

  def owner
    @advertisement = Advertisement.find(params[:id])
    if @advertisement.user_id == current_user.id
      render :json => {result: 'OK'}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR'}.to_json , :callback => params['callback']
    end
  end

  def make_pin
    @advertisement = Advertisement.find(params[:id])
    if current_user
      @user_id = current_user.id
    else
      @user_id = ''
    end
    @pin = Pin.new(advertisement_id: @advertisement.id, user_id: @user_id, device_id: params[:device_id])
    if @pin.save
      render :json => {result: 'OK', pin: @pin}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def unpin
    @advertisement = Advertisement.find(params[:id])
    if current_user
      @user_id = current_user.id
    else
      @user_id = ''
    end
    @pin = Pin.where('advertisement_id = ? AND ( user_id = ? OR device_id = ?)', @advertisement.id, @user_id, params[:device_id]).first
    if !@pin.blank?
      @pin.destroy
      render :json => {result: 'OK'}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def pinned
    @advertisement = Advertisement.find(params[:id])
    if current_user
      @user_id = current_user.id
    else
      @user_id = ''
    end
    @pin = Pin.where('advertisement_id = ? AND ( user_id = ? OR device_id = ?)', @advertisement.id, @user_id, params[:device_id]).first
    if !@pin.blank?
      render :json => {result: 'OK'}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def liked
    @advertisement = Advertisement.find(params[:id])
    if current_user
      @user_id = current_user.id
    else
      @user_id = ''
    end
    @like = Like.where('likeable_id = ? AND ( user_id = ? OR device_id = ?)', @advertisement.id, @user_id, params[:device_id]).first
    if !@like.blank?
      @likes = Like.where(likeable_id: @advertisement.id).count
      render :json => {result: 'OK', likes: @likes}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def like
    @advertisement = Advertisement.find(params[:id])
    if current_user
      @user_id = current_user.id
    else
      @user_id = ''
    end
    @like = Like.new(likeable_id: @advertisement.id, likeable_type: 'Advertisement', user_id: @user_id, device_id: params[:device_id])
    if @like.save
      @likes = Like.where(likeable_id: @advertisement.id).count
      render :json => {result: 'OK', likes: @likes}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def dislike
    @advertisement = Advertisement.find(params[:id])
    if current_user
      @user_id = current_user.id
    else
      @user_id = ''
    end
    @like = Like.where('likeable_id = ? AND ( user_id = ? OR device_id = ?)', @advertisement.id, @user_id, params[:device_id]).first
    if !@like.blank?
      @like.destroy
      @likes = Like.where(likeable_id: @advertisement.id).count
      render :json => {result: 'OK', likes: @likes}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def messages
    @advertisement = Advertisement.find(params[:id])
    if @advertisement.user_id != current_user.id
      @room = Room.where(advertisement_id: @advertisement.id, user_id: current_user.id).first
    else
      @room = Room.find(params[:room_id])
    end
    if !@room.blank?
      @messages = Message.where(room_id: @room.id).order('created_at desc').paginate(:page => params[:page], :per_page => 10)
      if !@messages.blank?
        @result = []
        for message in @messages
          if message.user_id == current_user.id
            @type = 'sent'
          else
            @type = 'received'
          end
          @result << {text: message.content, type: @type}
        end
        @seen = Seen.create(user_id: current_user.id, room_id: @room.id)
        render :json => {result: 'OK', messages: @result, room_id: @room.id}.to_json , :callback => params['callback']
      else
        render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
      end
    end
  end

  def grouped_messages
    @result = []
    current_user.rooms.all.group_by(&:advertisement).each do |ad, rooms|
      @rooms = []
      @count = 0
      for room in rooms
        @seen = Seen.where(user_id: current_user.id, room_id: room.id).order('created_at desc').first
        if !@seen.blank?
          @count += Message.where('room_id = ? and created_at > ?', room.id, @seen.created_at).count
        else
          @count += Message.where('room_id = ?', room.id).count
        end
        @rooms << {id: room.id, profile: room.user.profile.name}
      end
      @result << {id: ad.id, title: ad.title, rooms: @rooms, count: @count}
    end
    if !@result.blank?
      render :json => {result: 'OK', result: @result}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def admin_grouped_messages
    @result = []
     Room.all.joins(:advertisement).where(advertisements: {user_id: current_user.id}).group_by(&:advertisement).each do |ad, rooms|
      @rooms = []
      @count = 0
      for room in rooms
        @seen = Seen.where(user_id: current_user.id, room_id: room.id).order('created_at desc').first
        if !@seen.blank?
          @count += Message.where('room_id = ? and created_at > ?', room.id, @seen.created_at).count
        else
          @count += Message.where('room_id = ?', room.id).count
        end
        @rooms << {id: room.id, profile: room.user.profile.name}
      end
      @result << {id: ad.id, title: ad.title, rooms: @rooms, count: @count}
    end
    if !@result.blank?
      render :json => {result: 'OK', result: @result}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def rooms
    @advertisement = Advertisement.find(params[:id])
    @rooms = @advertisement.rooms
    @result = []
    for room in @rooms
      @count = 0
      @seen = Seen.where(user_id: current_user.id, room_id: room.id).order('created_at desc').first
      if !@seen.blank?
        @count += Message.where('room_id = ? and created_at > ?', room.id, @seen.created_at).count
      else
        @count += Message.where('room_id = ?', room.id).count
      end
      @result << {id: room.id, advert_id: @advertisement.id,title: room.user.profile.name, count: @count}
    end

    if !@result.blank?
      render :json => {result: 'OK', result: @result}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def new_message
    @advertisement = Advertisement.find(params[:id])
    if @advertisement.user_id != current_user.id
      @room = Room.where(advertisement_id: @advertisement.id, user_id: current_user.id).first
      if !@room.blank?
        @message = Message.create(room_id: @room.id, user_id: current_user.id, content: params[:content])
      else
        @room = Room.create(advertisement_id: @advertisement.id, user_id: current_user.id)
        @message = Message.create(room_id: @room.id, user_id: current_user.id, content: params[:content])
      end
    else
      @room = Room.find(params[:room_id])
      @message = Message.create(room_id: @room.id, user_id: current_user.id, content: params[:content])
    end
    if !@message.blank?
      @seen = Seen.create(user_id: current_user.id, room_id: @room.id)
      @result = {text: @message.content, type: 'sent'}
      render :json => {result: 'OK', message: @result}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def seen
    @room = Room.find(params[:id])
    @seen = Seen.create(user_id: current_user.id, room_id: @room.id)
    if !@seen.blank?
      render :json => {result: 'OK'}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def user_advert_room
    @advertisement = Advertisement.find(params[:id])
    @room = Room.where(advertisement_id: @advertisement.id, user_id: current_user.id).first
    if !@room.blank?
      render :json => {result: 'OK', room: @room}.to_json , :callback => params['callback']
    else
      render :json => {error: 'ERROR' }.to_json , :callback => params['callback']
    end
  end

  def all_unseens
    @admin_rooms =  Room.all.joins(:advertisement).where(advertisements: {user_id: current_user.id})
    @count = 0
    for room in @admin_rooms
      @seen = Seen.where(user_id: current_user.id, room_id: room.id).order('created_at desc').first
      if !@seen.blank?
        @count += Message.where('room_id = ? and created_at > ?', room.id, @seen.created_at).count
      else
        @count += Message.where('room_id = ?', room.id).count
      end
    end
    @rooms = Room.where(user_id: current_user.id)
    for room in @rooms
      @seen = Seen.where(user_id: current_user.id, room_id: room.id).order('created_at desc').first
      if !@seen.blank?
        @count += Message.where('room_id = ? and created_at > ?', room.id, @seen.created_at).count
      else
        @count += Message.where('room_id = ?', room.id).count
      end
    end
    render :json => {result: 'OK', count: @count}.to_json , :callback => params['callback']
  end


  def is_admin
    if current_user.blank?
      head(403)
    end
  end

end
