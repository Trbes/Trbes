class UpdateRoleToMember
  include Interactor

  def call
    publish_everything
  end

  private

  def publish_everything
    context.membership.posts.each(&:published!)
    context.membership.comments.each(&:published!)
  end
end
