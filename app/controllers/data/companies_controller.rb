class Data::CompaniesController < Data::BaseController
  before_action :find_company, :only => [:show, :edit, :update, :destroy, :people]

  def index
    @companies = Company.where('name ILIKE ?', "%#{params[:search]}%")
    respond_to do |format|
      format.html
      format.xml { render xml: @companies.map(&:api_record), root: "companies" }
      format.json { render json: { companies: @companies.map(&:api_record) } }
    end
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to data_company_path(@company), :notice => "Added new company."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'new'
    end
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @company.api_record }
      format.json { render json: @company.api_record }
    end
  end

  def edit

  end

  def update
    if @company.update_attributes(company_params)
      redirect_to data_company_path(@company), :notice => "Company has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  def destroy
    @company.destroy
    redirect_to data_companies_path, :notice => "Company has been deleted."
  end
  
  def people
    @people = @company.people
    respond_to do |format|
      format.html
      format.pdf do
        mark_printed(@people)
        send_badge(@people)
      end
    end
  end

  private
    def find_company
      @company = Company.find(params[:id])
    end
    def company_params
      params.require(:company).permit(
        :name, :address1, :address2, :city, :state_name, :country_name, :sector_id
      )
    end
end
