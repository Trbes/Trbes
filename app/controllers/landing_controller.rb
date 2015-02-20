class LandingController < ApplicationController
  expose(:groups, only: [:explore]) do
    presented_groups = view_context.present(Group.all_public.includes(:logo))
    Kaminari.paginate_array(presented_groups).page(params[:page]).per(10)
  end

  def index
    render (params[:teams] ? "teams" : "customer_communities"), layout: "landing"
  end

  def explore
  end
end
