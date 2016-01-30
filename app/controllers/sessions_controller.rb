class SessionsController < ApplicationController

  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    session[:user_id] = user.id if not user.nil?
    redirect_to user
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

end