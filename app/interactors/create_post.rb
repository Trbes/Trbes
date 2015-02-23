class CreatePost
  include Pundit
  include Interactor

  def call
    context.post = create_post
  end

  private

  def create_post
    Post.create(
      attributes.merge(
        user: context.current_user,
        group: context.current_group,
        attachments_attributes: attributes[:attachments_attributes] || [],
        state: policy(Post).publish? ? :published : :moderation
      )
    )
  end

  def pundit_user
    context.current_user.membership_for(context.current_group)
  end

  def attributes
    context.attributes
  end
end
