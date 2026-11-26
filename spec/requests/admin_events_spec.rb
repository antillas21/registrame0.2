require "spec_helper"

describe "Admin events", :type => :request do
  it "renders the date selects on the edit form" do
    sign_in_as(create_user(:admin => true))
    event = Event.create!(:name => "Expo", :date => Date.new(2026, 6, 15))

    get "/admin/events/#{event.id}/edit"

    expect(response.status).to eq(200)
    expect(response.body).to include("Expo")
    expect(response.body).to include('name="event[date(1i)]"')
  end
end
