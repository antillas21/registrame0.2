class CountriesController < ApplicationController
  def index
    @countries = Country.all
    respond_to do |format|
      format.xml { render :xml => @countries }
    end
  end

  def new
    @country = Country.new
  end

  def create
    #@country = Country.new(country_params)
    #@country.save
    @country = Country.create!(country_params)
  end
  private
    def country_params
      params.require(:country).permit(:name)
    end
end
