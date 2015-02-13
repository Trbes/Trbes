class Post < ActiveRecord::Base
  belongs_to :postable, polymorphic: true
  has_many :attachments, as: :attachable
end

class TextPostable < ActiveRecord::Base
  has_many :attachments, as: :attachable
end
class LinkPostable < ActiveRecord::Base; end
class ImagePostable < ActiveRecord::Base
  has_many :attachments, as: :attachable
end

class GetRidOfPostables < ActiveRecord::Migration
  def change
    add_column :posts, :post_type, :integer, default: 0, null: false
    add_column :posts, :body, :string

    Post.all.each do |post|
      post.attachments << post.postable.attachments

      if post.postable.respond_to?(:link)
        post.update_attributes(body: post.postable.link)
      elsif post.postable.respond_to?(:body)
        post.update_attributes(body: post.postable.body)
      end

      post.update_attributes(post_type: post.postable.class.to_s.underscore.split("_").first)
    end

    [TextPostable, LinkPostable, ImagePostable].each(&:destroy_all)

    remove_columns :posts, :postable_type, :postable_id
  end
end
