require "spec_helper"

describe User do
  it "finds a user by username or email" do
    user = create_user(:username => "ada", :email => "ada@example.com")

    by_username = User.find_for_database_authentication(:login => "ada")
    by_email = User.find_for_database_authentication(:login => "ada@example.com")

    expect(by_username).to eq(user)
    expect(by_email).to eq(user)
  end
end
