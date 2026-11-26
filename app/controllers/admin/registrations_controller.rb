class Admin::RegistrationsController < Admin::BaseController
  before_action :find_registration, :only => [:show, :edit, :update, :destroy]

  def index
    @registrations = Registration.all
  end

  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.save
      redirect_to admin_registrations_path, :notice => "Added new registration type."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'new'
    end
  end

  def show

  end

  def edit

  end

  def update
    if @registration.update(registration_params)
      redirect_to admin_registrations_path, :notice => "Registration type has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  def destroy
    @registration.destroy
    redirect_to admin_registrations_path, :notice => "Registration type has been deleted."
  end

  private
    def find_registration
      @registration = Registration.find(params[:id])
    end
    def registration_params
      params.require(:registration).permit(:name)
    end
end
