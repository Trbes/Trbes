class CreatePost
  include Interactor

  def call
    context.post = create_post
  end

  private

  def create_post
    postable = attributes[:postable_type].constantize.create!(attributes[:postable_attributes])

    Post.create!(
      postable: postable,
      user: context.current_user,
      group: context.current_group
    )
  end

  def attributes
    context.attributes
  end
end
