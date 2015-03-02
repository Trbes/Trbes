class CreateComment
  include Interactor

  def call
    context.comment = create_comment
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
