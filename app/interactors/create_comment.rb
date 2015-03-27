class CreateComment
  include Interactor

  def call
    context.comment = create_comment

    context.message = I18n.t("app.comment.message.success_pending") if
      context.user.membership_for(context.post.group).try(:pending?)
  end

  private

  def create_comment
    Comment.create!(
      context.attributes.merge(
        user: context.user,
        post: context.post,
        state: context.allow_publish ? :published : :moderation
      )
    )
  end
end
