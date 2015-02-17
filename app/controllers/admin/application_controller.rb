module Admin
  class ApplicationController < ::ApplicationController
    before_action :authorize_admin!

    protected

    def authorize_admin!
      authorize(:access, :admin_access?)
    end
  end
end
