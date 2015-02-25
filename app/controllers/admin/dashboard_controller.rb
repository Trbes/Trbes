module Admin
  class DashboardController < Admin::ApplicationController
    expose(:group) { view_context.present(current_group) }
    expose(:latest_posts) do
      group.posts.order_by_created_at.limit(4).includes(user: :avatar).map { |post| view_context.present(post) }
    end
  end
end
