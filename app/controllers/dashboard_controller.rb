class DashboardController < ApplicationController
  def index
  end

  def welcome
    render(current_group ? "dashboard/welcome" : "dashboard/welcome_create_group")
  end
end
