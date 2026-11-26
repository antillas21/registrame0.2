class Person < ApplicationRecord
  before_validation :strip_quotes
  validates_presence_of :fname, :lname, :email, :phone, :registration
  validates_uniqueness_of :email, :case_sensitive => false
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, :with => EmailRegex
  validates_length_of :phone, :is => 14, :wrong_length => "should be in the format of (XXX) XXX-XXXX"

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :promotions
  belongs_to :registration
  belongs_to :company, optional: true
  accepts_nested_attributes_for :company

  def api_record
    {
      "first_name" => fname,
      "last_name" => lname,
      "email" => email,
      "job" => job,
      "company" => company_name,
      "registration_type" => registration_name,
      "interests" => interests.map { |interest| { "name" => interest.name } },
      "promotions" => promotions.map { |promotion| { "name" => promotion.name } }
    }
  end

  scope :attended, lambda { where("printed = ?", true) }
  delegate :name, :to => :registration, :prefix => true
  delegate :name, :address1, :city, :to => :company, :prefix => true
  delegate :name, :to => :promotions, :prefix => true
  delegate :name, :to => :interests, :prefix => true

  def full_name
    [fname, lname].join(' ')
  end

  def company_name
    company.name if company
  end

  def company_name=(name)
    self.company = Company.find_or_create_by(name: name) unless name.blank?
  end

  def profile(options = {})
    attributes = [:full_name, :email, :phone, :job]
    attributes.map do |attribute|
    self.send(attribute)
    end.reject(&:blank?).compact
  end

  def company_profile
    company.profile if company
  end

  def registration_name
    registration.name if registration
  end

  def strip_quotes
    self.fname = self.fname.to_s.gsub("\"", "")
    self.lname = self.lname.to_s.gsub("\"", "")
    self.job = self.job.to_s.gsub("\"", "")
  end

  def mecard
    "MECARD:N:#{full_name};TEL:#{phone};EMAIL:#{email};NOTE:#{company_name};;"
  end
end