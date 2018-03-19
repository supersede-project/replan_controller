class Schedule < ApplicationRecord
  belongs_to :plan
  has_one :resource
  has_one :feature
end