class MoveImageToGroupAndUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :groups, :logo, :string

    Group.all.each do |group|
      if old_logo = Attachment.find_by(attachable_type: "Group", attachable_id: group.id)
        group.update_attributes(logo: old_logo.read_attribute(:image))
      end
    end

    User.all.each do |user|
      if old_avatar = Attachment.find_by(attachable_type: "User", attachable_id: user.id)
        user.update_attributes(avatar: old_avatar.read_attribute(:image))
      end
    end
  end
end
