class UpdateMembership
  class UpdateRoleToMember
    include Interactor

    def call
      publish_everything
    end

    private

    def publish_everything
      membership.posts.moderation.each(&:published!)
      membership.comments.moderation.each(&:published!)
    end

    def membership
      context.membership
    end
  end
end
