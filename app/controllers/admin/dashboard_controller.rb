module Admin
  class DashboardController < ApplicationController
    expose(:group) { view_context.present(current_group) }

    def index
      authorize :admin_dashboard, :index?
    end
  end
end
