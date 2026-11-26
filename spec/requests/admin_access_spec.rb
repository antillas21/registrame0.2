require "spec_helper"

describe "Admin access", :type => :request do
  it "sends a non-admin user back to the root" do
    user = create_user(:admin => false)
    sign_in_as(user)

    get "/admin"

    expect(response).to redirect_to("/")
    expect(flash[:alert]).to eq("You must be an admin to do that.")
  end

  it "opens the admin index for an admin" do
    user = create_user(:admin => true)
    sign_in_as(user)

    get "/admin"

    expect(response.status).to eq(200)
  end
end
