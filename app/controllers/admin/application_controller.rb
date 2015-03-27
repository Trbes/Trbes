module Admin
  class ApplicationController < ::ApplicationController
    before_action :authorize_admin!, :set_group_name_for_title

    protected

    def set_group_name_for_title
      @group_name ||= current_group.name
    end

    def authorize_admin!
      authorize(:access, :admin_access?)
    end
  end
end
