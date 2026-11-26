require "spec_helper"

describe "Sessions", :type => :request do
  it "signs in with a username" do
    create_user(:username => "ada", :email => "ada@example.com")

    post "/users/sign_in", :user => { :login => "ada", :password => "password" }
    follow_redirect!

    expect(response.body).to include("Signed in successfully")
  end

  it "signs in with an email" do
    create_user(:username => "ada", :email => "ada@example.com")

    post "/users/sign_in", :user => { :login => "ada@example.com", :password => "password" }
    follow_redirect!

    expect(response.body).to include("Signed in successfully")
  end
end
