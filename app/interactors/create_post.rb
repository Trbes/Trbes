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
        user: context.current_user,
        group: context.current_group,
        attachments_attributes: attributes[:attachments_attributes] || [],
        state: context.allow_publish ? :published : :moderation
      )
    )
  end

  def pending_membership
    context.current_user.membership_for(context.current_group).pending?
  end

  def set_failure_message
    context.message = context.post.errors.full_messages.join(". ")
  end

  def set_success_message
    context.message = if pending_membership
      I18n.t("app.post.message.success_pending", title: context.post.title)
    else
      I18n.t("app.post.message.success", title: context.post.title)
    end
  end

  def attributes
    context.attributes
  end
end
