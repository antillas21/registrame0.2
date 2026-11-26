class Admin::EventsController < Admin::BaseController
  before_action :find_event, :only => [:show, :edit, :update]

  def index
    @events = Event.all
    respond_to do |format|
      format.html
      format.xml { render xml: @events, root: "events" }
      format.json { render json: { events: @events } }
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_events_path, :notice => "Added new event."
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
    if @event.update_attributes(event_params)
      redirect_to admin_events_path, :notice => "Event info has been updated."
    else
      flash[:error] = "There were some errors. Please correct them before proceeding."
      render 'edit'
    end
  end

  private
    def find_event
      @event = Event.find(params[:id])
    end
    def event_params
      params.require(:event).permit(:name, :venue, :info, :date, :website)
    end
end
