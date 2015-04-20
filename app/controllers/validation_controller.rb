class ValidationController < ApplicationController
  expose(:user, attributes: :user_attributes)
  expose(:group, attributes: :group_attributes)

  def user_email
    render json: true and return if user.valid? || user.errors[:email].blank?

    render json: [user.errors[:email].map { |m| "Email #{m}" }.join("; ")]
  end

  def group_name
    render json: true and return if group.valid? || group.errors[:name].blank?

    render json: [group.errors[:name].map { |m| "Group name #{m}" }.join("; ")]
  end

  def group_subdomain
    render json: true and return if group.valid? || group.errors[:subdomain].blank?

    render json: [group.errors[:subdomain].map { |m| "Short name #{m}" }.join("; ")]
  end

  def group_tagline
    render json: true and return if group.valid? || group.errors[:tagline].blank?

    render json: [group.errors[:tagline].map { |m| "Tag line #{m}" }.join("; ")]
  end

  private

  def user_attributes
    params.require(:user).permit(
      :email,
      :password
    )
  end

  def group_attributes
    params.require(:group).permit(
      :name,
      :subdomain,
      :tagline
    )
  end
end
