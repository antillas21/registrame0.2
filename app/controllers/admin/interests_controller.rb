class Admin::InterestsController < Admin::BaseController
  before_action :find_interest, :only => [:show, :edit, :update, :destroy]

  def index
    @interests = Interest.all
    respond_to do |format|
      format.html
      format.xml { render xml: @interests.as_json(only: :name), root: "interests" }
      format.json { render json: { interests: @interests.as_json(only: :name) } }
    end
  end

  def new
    @interest = Interest.new
  end

  def create
    @interest = Interest.new(interest_params)
    if @interest.save
      redirect_to admin_interests_path, :notice => "Added new interest."
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
    if @interest.update_attributes(interest_params)
      redirect_to admin_interests_path, :notice => "Interest has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  def destroy
    @interest.destroy
    redirect_to admin_interests_path, :notice => "Interest has been deleted."
  end

  private
    def find_interest
      @interest = Interest.find(params[:id])
    end
    def interest_params
      params.require(:interest).permit(:name)
    end
end
