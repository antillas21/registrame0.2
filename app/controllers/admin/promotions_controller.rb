class Admin::PromotionsController < Admin::BaseController
  before_action :find_promotion, :only => [:show, :edit, :update, :destroy]

  def index
    @promotions = Promotion.all
    respond_to do |format|
      format.html
      format.xml { render xml: @promotions.as_json(only: :name), root: "promotions" }
      format.json { render json: { promotions: @promotions.as_json(only: :name) } }
    end
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      redirect_to admin_promotions_path, :notice => "Added new promotion media."
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
    if @promotion.update_attributes(promotion_params)
      redirect_to admin_promotions_path, :notice => "Promotion media has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  def destroy
    @promotion.destroy
    redirect_to admin_promotions_path, :notice => "Promotion media has been deleted."
  end

  private
    def find_promotion
      @promotion = Promotion.find(params[:id])
    end
    def promotion_params
      params.require(:promotion).permit(:name)
    end
end
