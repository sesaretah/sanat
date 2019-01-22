class Like < ActiveRecord::Base
  self.primary_key = 'uuid'

  belongs_to :likeable, :polymorphic => true
  belongs_to :advertisement, :class_name => "Advertisement", :foreign_key => "likeable_id"

  before_create :set_uuid
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def id
    self.uuid
  end

  def self.find(uuid)
    Like.find_by_uuid(uuid)
  end
end
