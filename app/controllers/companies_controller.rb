class CompaniesController < ApplicationController
  before_action :find_company, :only => [:show, :edit, :update, :destroy]

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
      redirect_to @company, :notice => "Added new company."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'new'
    end
  end

  #def show
   # respond_to do |format|
    #  format.html
    #  format.xml { render xml: @company.api_record }
    #  format.json { render json: @company.api_record }
    #end
  #end

  def edit

  end

  def update
    if @company.update(company_params)
      redirect_to person_path(session[:person_id]), :notice => "Thank you for updating your company record. <strong>This step completes your registration</strong>".html_safe
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  #def destroy
   # @company.destroy
    #redirect_to companies_path, :notice => "Company has been deleted."
  #end

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
