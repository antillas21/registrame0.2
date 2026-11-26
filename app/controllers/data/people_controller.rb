class Data::PeopleController < Data::BaseController
  before_action :find_person, :only => [:show, :edit, :update, :destroy]

  def index
    @people = Person.all
    respond_to do |format|
      format.html
      format.xml { render xml: @people.map(&:api_record), root: "people" }
      format.json { render json: { people: @people.map(&:api_record) } }
    end
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to data_person_path(@person), :notice => 'Added a new attendee.'
    else
      flash[:error] = 'There were some errors. Please correct them before proceeding.'
      render 'new'
    end
  end

  def edit

  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @person.api_record }
      format.json { render json: @person.api_record }
      format.pdf do
        mark_printed(@person)
        send_badge(@person)
      end
    end
  end

  def update
    if @person.update_attributes(person_params)
      redirect_to data_person_path(@person), :notice => "Attendee has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  def destroy
    @person.destroy
    redirect_to data_people_path, :notice => "Attendee has been deleted."
  end
  
  private
    def find_person
      @person = Person.find(params[:id])
    end
    def person_params
      params.require(:person).permit(
        :fname, :lname, :email, :phone, :job, :company_name, :registration_id,
        :interest_ids => [], :promotion_ids => []
      )
    end
end
