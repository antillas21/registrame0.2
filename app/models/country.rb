class Country < ApplicationRecord
  validates :name, :presence => true
  has_many :companies
  default_scope { order('name asc') }
end

