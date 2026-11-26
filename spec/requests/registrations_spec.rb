require "spec_helper"

describe "Public registration", :type => :request do
  before do
    Event.create!(:name => "Expo", :date => Date.today)
  end

  it "creates an attendee and sends a confirmation" do
    registration = create_registration("Visitor")

    post "/people", :person => {
      :fname => "John",
      :lname => "Doe",
      :email => "john@example.com",
      :phone => "(415) 555-1212",
      :registration_id => registration.id,
      :company_name => "Acme"
    }

    person = Person.find_by_email("john@example.com")
    expect(person).to be_present
    expect(person.company_name).to eq("Acme")
    expect(ActionMailer::Base.deliveries.size).to eq(1)
    expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
  end

  it "renders the form again when the attendee is invalid" do
    post "/people", :person => { :fname => "John" }

    expect(response.status).to eq(200)
    expect(Person.count).to eq(0)
    expect(response.body).to include("Register")
  end
end
