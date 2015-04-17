class Group
  has_one :logo, as: :attachable, class_name: "Attachment"
end

class User
  has_one :avatar, as: :attachable, class_name: "Attachment"
end

class MoveImageToGroupAndUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :groups, :logo, :string

    Group.all.each do |group|
      if group.logo
        group.update_attributes(logo: group.logo.read_attribute(:image))
      end
    end

    User.all.each do |user|
      if user.avatar
        user.update_attributes(avatar: user.avatar.read_attribute(:image))
      end
    end
  end
end
