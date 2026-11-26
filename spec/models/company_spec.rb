require "spec_helper"

describe Company do
  it "finds or creates a state by name" do
    existing = State.create!(:name => "Jalisco")
    company = Company.new(:name => "Acme")
    company.state_name = "Jalisco"
    expect(company.state).to eq(existing)

    company.state_name = "Nayarit"
    expect(State.find_by_name("Nayarit")).to be_present
  end

  it "finds or creates a country by name" do
    existing = Country.create!(:name => "Mexico")
    company = Company.new(:name => "Acme")
    company.country_name = "Mexico"
    expect(company.country).to eq(existing)

    company.country_name = "Canada"
    expect(Country.find_by_name("Canada")).to be_present
  end
end
