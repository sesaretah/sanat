class Advertisement < ActiveRecord::Base
  self.primary_key = 'uuid'
  after_save ThinkingSphinx::RealTime.callback_for(:advertisement)

  belongs_to :category
  belongs_to :user
  has_many :likes, :as => :likeable, :dependent => :destroy
  has_many :rooms
  has_many :pins
  belongs_to :province

  def cover(style)
    @upload = Upload.where(uploadable_id: self.id, attachment_type: 'attachment_photos').first
    if !@upload.blank?
      return @upload.attachment(style)
    else
      ActionController::Base.helpers.asset_path("#{rand(2..6)}.png", :digest => false)
    end
  end

  def photos(style)
    @uploads = Upload.where(uploadable_id: self.id, attachment_type: 'attachment_photos')
    if !@uploads.blank?
      @images = []
      for upload in @uploads
        @images << {url: upload.attachment(style), id: upload.id}
      end
      return @images
    else
      return [{url: ActionController::Base.helpers.asset_path("noimage-35-#{style}.jpg", :digest => false), id: nil}]
    end
  end

  before_create :set_integer_id
  def set_integer_id
    @last = Advertisement.all.order('integer_id desc').first
    if !@last.blank?
      @last_id = @last.integer_id
    else
      @last_id = 0
    end
    self.integer_id = @last_id + 1
  end


  before_create :set_rank
  def set_rank
    self.rank = 0
  end


  before_create :set_uuid
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def id
    self.uuid
  end

  def self.find(uuid)
    Advertisement.find_by_uuid(uuid)
  end
end
