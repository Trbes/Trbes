module Admin
  class DashboardController < Admin::ApplicationController
    expose(:group) { view_context.present(current_group) }
  end
end
