class PostCreator
  include Interactor

  def call
    context.post = create_post
  end

  private

  def create_post
    Post.create!(
      context.attributes.merge(
        user: context.current_user,
        group: context.current_group
      )
    )
  end
end
