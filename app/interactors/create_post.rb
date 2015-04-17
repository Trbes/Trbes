class CreatePost
  include Interactor

  def call
    create_post

    if context.post.valid?
      set_success_message
    else
      set_failure_message

      context.fail!
    end
  end

  private

  def create_post
    context.post = Post.create(
      attributes.merge(
        membership: context.current_membership,
        group: context.current_membership.group,
        attachments_attributes: attributes[:attachments_attributes] || [],
        state: context.allow_publish ? :published : :moderation
      )
    )
  end

  def set_failure_message
    context.message = context.post.errors.full_messages.join(". ")
  end

  def set_success_message
    context.message = if context.current_membership.pending?
      I18n.t("app.post.message.success_pending", title: context.post.title)
    else
      I18n.t("app.post.message.success", title: context.post.title)
    end
  end

  def attributes
    context.attributes
  end
end
