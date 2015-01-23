module PostsHelper
  def postable_name(post)
    post.postable.class.to_s.underscore
  end

  def human_name(postable)
    postable.to_s.underscore.humanize.titleize.gsub("able", "")
  end
end
