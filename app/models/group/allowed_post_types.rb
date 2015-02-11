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

        @intended_usage.split(",").each do |type|
          next unless ALLOWED_POST_TYPES.include?(type.to_sym)

          send("allow_#{type}_posts=", true)
        end
      end
    end
  end
end
