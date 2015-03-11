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

  def sort_class(filter)
    params[:sort] == filter ? "active" : ""
  end

  def short_time_distance_string(time)
    a = (Time.now - time).to_i

    case a
      when 0 then '1s'
      when 1 then '1s'
      when 2..59 then a.to_s + 's'
      when 60..119 then '1m' #120 = 2 minutes
      when 120..3540 then (a / 60).to_i.to_s + 'm'
      when 3541..7100 then '1h' # 3600 = 1 hour
      when 7101..82800 then ((a + 99) / 3600).to_i.to_s + 'h'
      when 82801..172000 then '1d' # 86400 = 1 day
      when 172001..518400 then ((a + 800) / (60 * 60 * 24)).to_i.to_s + 'd'
      when 518400..1036800 then '1w'
      else ((a + 180000) / (60 * 60 * 24 * 7)).to_i.to_s + 'w'
    end
  end
end
