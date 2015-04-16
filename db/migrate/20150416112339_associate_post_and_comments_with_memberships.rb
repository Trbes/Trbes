class AssociatePostAndCommentsWithMemberships < ActiveRecord::Migration
  def change
    add_reference(:posts, :membership, index: true)
    add_reference(:comments, :membership, index: true)

    add_foreign_key :posts, :memberships
    add_foreign_key :comments, :memberships


    posts_count = Post.count

    Post.all.each_with_index do |post, index|
      if post.user.membership_for(post.group)
        puts "updating #{index} out of #{posts_count}"
        post.update_attributes(membership_id: post.user.membership_for(post.group).id)
      end
    end

    comments_count = Comment.count

    Comment.all.each_with_index do |comment, index|
      if comment.user.membership_for(comment.post.group)
          puts "updating #{index} out of #{comments_count}"
        comment.update_attributes(membership_id: comment.user.membership_for(comment.post.group).id)
      end
    end

    remove_column :posts, :user_id
    remove_column :comments, :user_id
  end
end
