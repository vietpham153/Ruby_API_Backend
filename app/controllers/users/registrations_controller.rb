# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  respond_to :json

  def destroy
    resource = User.find(current_user.id) # Tìm người dùng hiện tại
    if resource.destroy
      sign_out(resource_name) # Đăng xuất người dùng
      session.clear # Xóa session bằng cách thủ công
      render json: { message: 'Account deleted successfully.' }, status: :ok
    else
      render json: { message: 'Failed to delete the account.' }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    if request.method == 'POST' && resource.persisted?
      render json: { message: 'Signed up sucessfully.', data: resource }, status: :ok
    elsif request.method == 'DELETE'
      render json: { message: 'Account deleted successfully.' }, status: :ok
    else
      render json: { message: "User couldn't be created successfully.", errors: resource.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
end
