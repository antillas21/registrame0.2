require "spec_helper"

describe "Company search", :type => :request do
  before do
    sign_in_as(create_user)
    Company.create!(:name => "Acme Widgets")
  end

  it "finds a company regardless of case" do
    get "/data/companies.json", params: { search: "acme" }
    expect(response.body).to include("Acme Widgets")

    get "/data/companies.json", params: { search: "ACME" }
    expect(response.body).to include("Acme Widgets")
  end
end
