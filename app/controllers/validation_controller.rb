class ValidationController < ApplicationController
  expose(:user, attributes: :user_attributes)

  def email
    # render json: true and return
    render json: true and return if user.valid? || user.errors[:email].blank?

    render json: [user.errors[:email].each { |m| "Email #{m}" }.join("; ")]
  end

  private

  def user_attributes
    params.require(:user).permit(
      :email,
      :password
    )
  end
end
