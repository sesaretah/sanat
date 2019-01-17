class Upload < ActiveRecord::Base
  has_attached_file :attachment, :styles => { :medium => "300x300#", :tiny => "20x20>" ,:thumb => "50x50>", :large => "400x400>", :extra => "800X800>"  }, :default_url => "/assets/noimage-35-:style.jpg",  :processors => [:cropper]
  validates_attachment_content_type :attachment, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  do_not_validate_attachment_file_name :attachment
  belongs_to :uploadable, :polymorphic => true
  belongs_to :advertisement, :class_name => "Advertisement", :foreign_key => "uploadable_id"

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :ratio, :caller
  after_update :reprocess_avatar, :if => :cropping?
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(attachment.path(style))
  end


  private

  def reprocess_avatar
    attachment.assign(attachment)
    attachment.save
  end
end
