class Registration < ApplicationRecord
  validates :name, :presence => true
  has_many :people
end
