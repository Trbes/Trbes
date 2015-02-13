class Group
  module AllowedPostTypes
    extend ActiveSupport::Concern

    included do
      ALLOWED_POST_TYPES = %i( link text image )

      attr_accessor :intended_usage

      before_create :update_allowed_post_types

      private

      def update_allowed_post_types
        return if @intended_usage.blank?

        ALLOWED_POST_TYPES.select { |t| t != :image }.each do |type|
          send("allow_#{type}_posts=", @intended_usage.include?(type.to_s))
        end
      end
    end
  end
end
