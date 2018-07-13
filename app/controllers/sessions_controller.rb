class SessionsController < ApplicationController
  def new; end

  def create
    sess_param = params[:session]
    user = User.find_by email: sess_param[:email].downcase
    if user && user.authenticate(sess_param[:password])
      log_in user
      sess_param[:remember_me] == "1" ? remember(user) : forget(user)
      redirect_to user
    else
      flash[:danger] = t ".invalid"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
