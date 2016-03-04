class SessionsController < ApplicationController

  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if not user.isfrozen
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      end
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth
    user = User.find_by username: env["omniauth.auth"]["info"]["nickname"]
    if user
      if not user.isfrozen
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to signin_path, notice: "Your account is frozen, please contact admin"
      end
    else
      username = env["omniauth.auth"]["info"]["nickname"]
      create_oauth_user(username)
    end
  end

  def create_oauth_user(username)
    password = greate_password
    @user = User.new(username: username, password: password, password_confirmation: password, isfrozen: true)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      redirect_to signin_path, notice: 'Unable to login!'
    end
  end

  def greate_password
    while true
      password = SecureRandom.base64(12)
      break if password.match(/[A-Z]/) and password.match(/[[:digit:]]/) and password.length > 3
    end
    password
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

end