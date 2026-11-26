class Data::BaseController < ApplicationController
  before_action :authenticate_user!

  def index
    @registrations = Registration.all
    @people = Person.all
    @attendees = Person.attended
  end
end