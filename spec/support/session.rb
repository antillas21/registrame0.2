module SessionHelpers
  def sign_in_as(user, password = "password")
    post "/users/sign_in", params: { user: { login: user.username, password: password } }
    follow_redirect!
  end
end
