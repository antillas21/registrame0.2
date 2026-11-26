require "spec_helper"

describe "People API", :type => :request do
  before do
    sign_in_as(create_user)
  end

  it "keeps the attendee keys used by the data area" do
    registration = create_registration("Visitor")
    person = create_person(
      :fname => "Ada",
      :lname => "Lovelace",
      :email => "ada@example.com",
      :registration => registration
    )

    get "/data/people.json"
    payload = JSON.parse(response.body)
    record = payload.fetch("people").find { |item| item["email"] == "ada@example.com" }

    expect(record["first_name"]).to eq("Ada")
    expect(record["last_name"]).to eq("Lovelace")
    expect(record["registration_type"]).to eq("Visitor")
    expect(person.registration_name).to eq("Visitor")
  end
end
