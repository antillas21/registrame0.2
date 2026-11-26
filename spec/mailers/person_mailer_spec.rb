require "spec_helper"

describe PersonMailer do
  it "addresses the attendee and names the event" do
    Event.create!(:name => "Expo", :date => Date.today)
    person = create_person(:email => "ada@example.com")
    mail = PersonMailer.registration_confirmation(person)

    expect(mail.subject).to eq("Thanks for registering in Expo")
    expect(mail.to).to eq(["ada@example.com"])
  end
end
