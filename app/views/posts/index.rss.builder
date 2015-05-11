xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title current_group.name
    xml.description current_group.tagline
    xml.link root_url

    posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link post.link if post.link
        xml.description post.body if post.body
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.tag! "dc:creator", post.user_full_name
        xml.guid post_url(post)

        post.collections.each do |collection|
          xml.category collection.name
        end
      end
    end
  end
end
