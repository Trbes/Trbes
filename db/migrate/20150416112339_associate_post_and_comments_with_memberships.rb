class AssociatePostAndCommentsWithMemberships < ActiveRecord::Migration
  def change
    add_reference(:posts, :membership, index: true)
    add_reference(:comments, :membership, index: true)

    add_foreign_key :posts, :memberships
    add_foreign_key :comments, :memberships

    posts_count = Post.count

    Post.without_auto_index do
      Post.all.each_with_index do |post, index|
        user = User.find_by(id: post.user_id)

        if user
          membership = user.membership_for(post.group)

          if membership
            puts "updating #{index} out of #{posts_count}"
            post.update_attributes(
              membership_id: membership.id
            )
          end
        end
      end
    end

    comments_count = Comment.count

    Comment.all.each_with_index do |comment, index|
      user = User.find_by(id: comment.user_id)

      if user
        membership = user.membership_for(comment.post.group)

        if membership
          puts "updating #{index} out of #{comments_count}"
          comment.update_attributes(
            membership_id: membership.id
          )
        end
      end
    end

    # remove_column :posts, :user_id, :integer
    # remove_column :comments, :user_id, :integer
  end
end
