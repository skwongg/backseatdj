def current_user
        # TODO: return the current user if there is a user signed in.
    session[:user]
  end

  def login_as_user(user)
    session[:user] = user.id
  end

  def logout!
    session[:user] = nil
  end

  def logged_in?
    !session[:user].nil?
  end

  def current_user
    User.where(id: session[:user]).first
  end