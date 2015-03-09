class CreatePost
  include Interactor

  def call
    context.post = create_post

    context.message = I18n.t("app.post.message.success", title: context.post.title) if context.success?
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
