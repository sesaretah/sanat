class Message < ActiveRecord::Base
  include Fcm
  self.primary_key = 'uuid'

  belongs_to :room
  belongs_to :user
  before_create :set_uuid
  after_save :send_notification
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def id
    self.uuid
  end

  def self.find(uuid)
    Message.find_by_uuid(uuid)
  end

  def send_notification
    @advertisement = self.room.advertisement
    @room = self.room
    @user_id = []
    if @advertisement.user_id == self.user_id
      @user_id << Message.where('room_id = ? and user_id <> ?', @room.id, self.user_id).first.pluck(:user_id)
    else
      @user_id << @advertisement.user_id
    end
    send_fcm(@user_id, self.user.profile.name , self.content,  'Room', @room.id)
  end
end
