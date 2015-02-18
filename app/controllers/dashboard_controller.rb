class DashboardController < ApplicationController
  def index
    redirect_to "/teams" and return unless user_signed_in?
  end
end
