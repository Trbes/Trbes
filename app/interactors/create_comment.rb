class CreateComment
  include Interactor

  def call
    context.comment = create_comment

    if context.comment.valid?
      set_success_message
    else
      set_failure_message

      context.fail!
    end
  end

  private

  def set_success_message
    if context.membership.pending?
      context.message = I18n.t("app.comment.message.success_pending")
    else
      context.message = I18n.t("app.comment.message.success")
    end
  end

  def set_failure_message
    context.message = context.comment.errors.full_messages.join(". ")
  end

  def create_comment
    Comment.create(
      context.attributes.merge(
        membership: context.membership,
        post: context.post,
        state: context.allow_publish ? :published : :moderation
      )
    )
  end
end
