module PostsHelper
  def preview_image(post)
    return unless post.preview_image

    link_to post, class: "post-thumb" do
      cl_image_tag(post.preview_image.thumbnail)
    end
  end

  def share_link(post)
    post.link_post? ? post.link : post_url(post, subdomain: current_group.subdomain)
  end

  def share_body(post)
    post.text_post? ? post.body.to_s : "Source: trbes.com"
  end

  def tweet_intent(post)
    opts = {
      text: post.title,
      url: share_link(post),
      via: "trbesapp"
    }

    params = []
    opts.each { |key, value| params << "#{key}=#{ URI.encode(value) }" }
    "https://twitter.com/intent/tweet?" + params.join("&")
  end
end
