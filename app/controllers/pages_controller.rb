class PagesController < ApplicationController
  def terms
    render layout: "application"
  end

  def home
    render layout: "landing"
  end
end
