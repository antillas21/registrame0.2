module SessionHelpers
  def sign_in_as(user, password = "password")
    post "/users/sign_in", :user => { :login => user.username, :password => password }
    follow_redirect!
  end
end
