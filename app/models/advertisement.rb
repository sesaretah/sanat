class Advertisement < ActiveRecord::Base
  self.primary_key = 'uuid'

  belongs_to :category
  belongs_to :user

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
