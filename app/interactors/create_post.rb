class CreatePost
  include Interactor

  def call
    context.post = create_post
  end

  private

  def create_post
    Post.create!(
      title: attributes[:title],
      body: attributes[:body],
      body: attributes[:link],
      post_type: attributes[:post_type],
      attachments_attributes: attributes[:attachments_attributes] || [],
      user: context.current_user,
      group: context.current_group
    )
  end

  def attributes
    context.attributes
  end
end
