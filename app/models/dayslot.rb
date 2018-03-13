class Dayslot < ApplicationRecord
  belongs_to :project
  has_one :resources
  has_one :feature
  validates :project_id, presence: true
end