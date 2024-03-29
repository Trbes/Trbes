class WelcomeController < ApplicationController
  expose :group

  def index
    # Only authorize current_user in this stage
    @authorize_current_user = true
    authorize :welcome, :index?

    # Turn off authorize current_membership (for views)
    @authorize_current_user = false

    params[:welcome] = true
    @trbes_group_url = ENV["TRBES_GROUP_ID"] ? group_url(Group.find(ENV["TRBES_GROUP_ID"])) : nil
    render view_for_welcome
  end

  private

  def pundit_user
    @authorize_current_user ? current_user : current_membership
  end

  def view_for_welcome
    current_group ? "welcome/index" : "groups/new"
  end
end
