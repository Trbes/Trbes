class CreatePost
  include Interactor

  def call
    context.post = create_post

    return unless context.success?

    if context.current_user.membership_for(context.current_group).pending?
      context.message = I18n.t("app.post.message.success_pending", title: context.post.title)
    else
      context.message = I18n.t("app.post.message.success", title: context.post.title)
    end
  end

  private

  def create_post
    Post.create(
      attributes.merge(
        user: context.current_user,
        group: context.current_group,
        attachments_attributes: attributes[:attachments_attributes] || [],
        state: context.allow_publish ? :published : :moderation
      )
    )
  end

  def attributes
    context.attributes
  end
end
