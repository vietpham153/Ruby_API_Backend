# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json

  def destroy
    sign_out(resource_name) # Đăng xuất người dùng
    session.clear # Xóa session thủ công
    respond_to_on_destroy
  end

  private
  #Optimise on error messages and also this method cannot give success results always
  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in successfully.', data: resource }, status: :ok
  end

  def respond_to_on_destroy
    if current_user.nil? # Kiểm tra nếu người dùng đã đăng xuất
      render json: { message: 'Logged out successfully' }, status: :ok
    else
      render json: { message: "Couldn't find an active session." }, status: :unauthorized
    end
  end
end
