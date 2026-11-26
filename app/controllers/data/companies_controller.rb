class Data::CompaniesController < Data::BaseController
  before_filter :find_company, :only => [:show, :edit, :update, :destroy, :people]

  def index
    @companies = Company.where('name ILIKE ?', "%#{params[:search]}%")
    respond_to do |format|
      format.html
      format.xml { render_for_api :name_only, :xml => @companies, :root => :companies }
      format.json { render_for_api :name_only, :json => @companies, :root => :companies }
    end
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(params[:company])
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
      format.xml { render_for_api :name_only, :xml => @company }
      format.json { render_for_api :name_only, :json => @company }
    end
  end

  def edit

  end

  def update
    if @company.update_attributes(params[:company])
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
end
