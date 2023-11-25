# frozen_string_literal: true

class SessionController < ApplicationController
  before_action :require_login!

  private

  def require_login!
    @current_user = User.find_by(id: session[:current_user_id]) and return \
        if session[:current_user_id].present?

    session[:destination_after_login] = request.env['REQUEST_URI']
    redirect_to login_url
  end
end
