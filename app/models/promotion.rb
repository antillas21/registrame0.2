class Promotion < ApplicationRecord
  validates :name, :presence => true
  has_and_belongs_to_many :people

  def to_s
    "#{self.name}"
  end
end
