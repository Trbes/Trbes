class PagesController < ApplicationController
  def small_teams
    @teams = true
  end

  def business
  end

  def terms
  end

  def home
    render layout: "landing"
  end
end
