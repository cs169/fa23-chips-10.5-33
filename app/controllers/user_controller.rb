# frozen_string_literal: true

class UserController < SessionController
  def profile
    @user = User.find_by(id: session[:current_user_id])
  end
end
