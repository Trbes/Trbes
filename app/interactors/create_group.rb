class CreateGroup
  include Interactor

  def call
    context.group = create_group
  end

  private

  def create_group
    context.attributes[:allow_image_posts] ||= false

    group = Group.new(context.attributes)
    group.add_member(context.user, as: :owner) if group.save

    group
  end
end
