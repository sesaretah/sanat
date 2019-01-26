class Province < ActiveRecord::Base
  self.primary_key = 'uuid'

  has_many :advertisements

  before_create :set_uuid
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def id
    self.uuid
  end

  def self.find(uuid)
    Province.find_by_uuid(uuid)
  end
end
