class Company < ActiveRecord::Base
  self.primary_key = 'uuid'

  before_create :set_uuid
  def set_uuid
    self.uuid = SecureRandom.uuid
  end

  def id
    self.uuid
  end

  def self.find(uuid)
    Company.find_by_uuid(uuid)
  end
end
