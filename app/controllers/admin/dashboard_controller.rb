module Admin
  class DashboardController < Admin::ApplicationController
    expose(:group) { view_context.present(current_group) }
    expose(:memberships, ancestor: :current_group) { |collection| collection.includes(user: :avatar) }
    expose(:latest_posts) do
      group.posts.order_by_created_at.limit(4).includes(membership: :user).map { |post| view_context.present(post) }
    end
  end
end
