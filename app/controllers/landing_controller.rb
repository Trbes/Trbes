class LandingController < ApplicationController
  def index
    render(params[:teams] ? "teams" : "customer_communities")
  end
end
