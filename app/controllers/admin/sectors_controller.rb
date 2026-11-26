class Admin::SectorsController < Admin::BaseController
  before_action :find_sector, :only => [:show, :edit, :update, :destroy]

  def index
    @sectors = Sector.all
  end

  def new
    @sector = Sector.new
  end

  def create
    @sector = Sector.new(sector_params)
    if @sector.save
      redirect_to admin_sectors_path, :notice => "Added new sector."
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
    if @sector.update(sector_params)
      redirect_to admin_sectors_path, :notice => "Sector has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  def destroy
    @sector.destroy
    redirect_to admin_sectors_path, :notice => "Sector has been deleted."
  end

  private
    def find_sector
      @sector = Sector.find(params[:id])
    end
    def sector_params
      params.require(:sector).permit(:name)
    end
end
