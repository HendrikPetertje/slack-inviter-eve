class InvitationsController < ApplicationController

  def new
    if authenticated?
      @invitation = Invitation.new
      return render 'new'
    else
      @current_user = SecureRandom.hex
      session[:current_user] = @current_user
      return render 'sign_in'
    end
  end

  def new_old
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)

    begin
      if @invitation.valid? && @invitation.perform
        flash[:success] = "Check your email!"
        redirect_to root_path and return
      else
        unprocessable
      end
    rescue
      unprocessable
    end
  end


  private

  def authenticated?
    return false if params[:state].blank? || session[:current_user].blank?
    return false unless params[:state] == session[:current_user]
    auth = EveAuth.new(eve_code: params[:code]).authenticated
    unless auth[:allowed_access]
      flash[:error] = 'Something went wrong, please try again. You can only join with alliance characters'
      return false
    end
    @name = auth[:name]
    true
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end

  def unprocessable
    redirect_to root_path, alert: 'sorry, there was an error' and return
  end

end
