class Person < ActiveRecord::Base
  before_validation :strip_quotes
  validates_presence_of :fname, :lname, :email, :phone, :registration
  validates_uniqueness_of :email, :case_sensitive => false
  EmailRegex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :email, :with => EmailRegex
  validates_length_of :phone, :is => 14, :wrong_length => "should be in the format of (XXX) XXX-XXXX"

  has_and_belongs_to_many :interests
  has_and_belongs_to_many :promotions
  belongs_to :registration
  belongs_to :company
  accepts_nested_attributes_for :company

  acts_as_api
  api_accessible :complete_record do |template|
    template.add :fname, :as => :first_name
    template.add :lname, :as => :last_name
    template.add :email
    template.add :job
    template.add :company_name, :as => :company
    template.add :registration_name, :as => :registration_type
    template.add :interests
    template.add :promotions
  end

  scope :attended, where("printed = ?", true)
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
    self.company = Company.find_or_create_by_name(name) unless name.blank?
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