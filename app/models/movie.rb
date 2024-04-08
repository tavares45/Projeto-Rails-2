class Movie < ApplicationRecord
  before_create :generate_uuid

  validates :title, uniqueness: { case_sensitive: false }

  private

  def generate_uuid
    self.uuid ||= UUID.new.generate
  end
end
