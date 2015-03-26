module Voting
  extend ActiveSupport::Concern

  included do
    def upvote
      resource.upvote_by(current_user)

      render json: {
        new_total_votes: resource.cached_votes_total,
        voted_up: true,
        new_vote_path: public_send("#{resource_name}_unvote_path", resource)
      }
    end

    def unvote
      resource.unvote_by(current_user)

      render json: {
        new_total_votes: resource.cached_votes_total,
        voted_up: false,
        new_vote_path: public_send("#{resource_name}_upvote_path", resource)
      }
    end

    def resource
      public_send(resource_name)
    end

    def resource_name
      self.class.name.downcase.gsub("controller", "").singularize
    end
  end
end
