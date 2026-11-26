class StatesController < ApplicationController
  def new
    @state = State.new
  end

  def create
    #@state = State.new(state_params)
    #@state.save
    @state = State.create!(state_params)
  end

  def index
    @states = State.all
    respond_to do |format|
      format.xml { render :xml => @states }
    end
  end

  private
    def state_params
      params.require(:state).permit(:name)
    end
end
