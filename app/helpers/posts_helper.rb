module PostsHelper
  def preview_image(post)
    return unless post.preview_image

    link_to post, class: "post-thumb" do
      cl_image_tag(post.preview_image.thumbnail)
    end
  end

  def post_share_link(post)
    post.link_post? ? post.link : post_url(post, subdomain: current_group.subdomain)
  end

  def post_share_body(post)
    post.text_post? ? post.body.to_s : "Source: trbes.com"
  end

  def post_tweet_intent(post)
    opts = {
      text: post.title,
      url: post_share_link(post),
      via: "trbesapp"
    }

    tweet_intent(opts)
  end

  def sort_class(filter)
    return "active" if filter == "order_by_votes" && !params[:sort] && !params[:collection_id]
    params[:sort] == filter ? "active" : ""
  end

  def collection_class(collection_id)
    params[:collection_id].to_i == collection_id ? "active" : ""
  end

  def post_vote_path(post, user)
    return new_user_registration_path unless user_signed_in?
    return "#" unless policy(post).vote?(user)

    user.voted_up_on?(post) ? post_unvote_path(post) : post_upvote_path(post)
  end

  def post_type_icon(post_type)
    {
      link_post: "link",
      text_post: "pencil",
      image_post: "photo"
    }[post_type.to_sym]
  end

  def post_type_title(post_type)
    {
      link_post: "Share a link",
      text_post: "Write something",
      image_post: "Post an image"
    }[post_type.to_sym]
  end

  def humanized_post_type(post_type)
    post_type.to_s.gsub("_post", "")
  end

  def post_states_options
    {
      "Active" => "all",
      "All" => "with_deleted",
      "Rejected" => "rejected",
      "Moderation" => "moderation",
      "Deleted" => "deleted"
    }
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
  def short_time_distance_string(time)
    a = (Time.now - time).to_i

    case a
    when 0 then "1s"
    when 1 then "1s"
    when 2..59 then a.to_s + "s"
    when 60..119 then "1m" # 120 = 2 minutes
    when 120..3_540 then (a / 60).to_i.to_s + "m"
    when 3_541..7_100 then "1h" # 3600 = 1 hour
    when 7_101..82_800 then ((a + 99) / 3_600).to_i.to_s + "h"
    when 82_801..172_000 then "1d" # 86400 = 1 day
    when 172_001..518_400 then ((a + 800) / (60 * 60 * 24)).to_i.to_s + "d"
    when 518_400..1_036_800 then "1w"
    else ((a + 180_000) / (60 * 60 * 24 * 7)).to_i.to_s + "w"
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
end
