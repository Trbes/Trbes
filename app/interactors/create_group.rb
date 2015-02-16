class CreateGroup
  include Interactor

  def call
    context.group = create_group
  end

  private

  def create_group
    group = Group.new(context.attributes)

    update_allowed_post_types(group) if group.intended_usage

    group.add_member(context.user, as: :owner) if group.save

    group
  end

  def update_allowed_post_types(group)
    Group::ALLOWED_POST_TYPES.select { |t| t != :image }.each do |type|
      group.send("allow_#{type}_posts=", group.intended_usage.include?(type.to_s))
    end
  end
end
