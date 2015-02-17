class CreatePost
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
        attachments_attributes: attributes[:attachments_attributes] || []
      )
    )
  end

  def attributes
    context.attributes
  end
end
