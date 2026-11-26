require "spec_helper"

describe "Passwords", :type => :request do
  it "renders the forgot-password form and reports a blank email" do
    get "/users/password/new"

    expect(response.status).to eq(200)
    expect(response.body).to include("Forgot your password?")

    post "/users/password", params: { user: { email: "" } }

    expect(response.status).to eq(200)
    expect(response.body).to include("Forgot your password?")
    expect(response.body).to include("Email can&#39;t be blank")
  end
end
