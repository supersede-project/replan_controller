class Dayslot < ApplicationRecord
  belongs_to :project
  has_and_belongs_to_many :resources
  validates :project_id, presence: true

end