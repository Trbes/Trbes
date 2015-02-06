module PostsHelper
  def preview_image(post)
    return unless post.preview_image

    link_to post, class: "post-thumb" do
      cl_image_tag(post.preview_image.thumbnail)
    end
  end
end
