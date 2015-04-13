namespace :db do
  desc "Import webdepart"
  # rubocop:disable all
  task import_webdepart: :environment do
    require "crack"

    user = User.find_by email: "archive@webdepart.com"

    user = User.create(
      email: "archive@webdepart.com",
      full_name: "Webdepart",
      password: "webdepart",
      password_confirmation: "webdepart",
      confirmed_at: Time.now
    ) unless user
    p "fetched user #{user}"

    group = Group.find_by subdomain: "webdepart"

    group = Group.create(
      name: "Webdepart",
      tagline: "The Webdepart archive",
      private: false,
      subdomain: "webdepart"
    ) unless group
    p "fetched group #{group}"

    group.add_member user, as: :moderator
    p "added user to group"

    data = Crack::XML.parse File.read("#{Rails.root}/db/data/webdepart.xml")
    p "parsed data file"

    posts = data['webdepart']['wd_posts']['row']
    users = data['webdepart']['wd_users']['row']
    post_count = posts.count

    Post.without_auto_index do
      posts.each_with_index do |post_data, index|
        begin
          if post_data["post_status"] != "publish"
            p "SKIPPED --> #{index} / #{post_count}."
            next
          end

          post_date = post_data["post_date"].split(" ")[0]
          post_slug = "#{post_date.split('-')[0]}/#{post_date.split('-')[1]}/#{CGI.unescape post_data['post_name']}/"

          # skip specific posts as per https://basecamp.com/2854999/projects/8291966/messages/40370888#comment_270167814
          next if %w(
            2012/07/tous-les-articles/
            2012/07/page-daccueil/
            2012/07/contact-form-1/
          ).include? post_slug

          post_body = post_data["post_content"] || ""
          post_body.gsub!("http://blog.webdepart.com/wp-content/", "http://media.webdepart.com/wp-content/")
          author = users.first{ |u| u["ID"] == post_data["post_author"] }
          meta_text = "ORIGINALLY PUBLISHED: #{post_date}"
          meta_text += " BY #{author['display_name'].upcase}" if author
          post_body = "<em>#{meta_text}</em><br><br>" + post_body

          result = CreatePost.call(
            attributes: {
              title: post_data["post_title"].html_safe,
              body: post_body,
              post_type: :text_post,
              slug: post_slug
            },
            current_group: group,
            current_user: user,
            allow_publish: true
          )

          p "--> #{index} / #{post_count}. #{result.message}"
        rescue => e
          p "FAILED --> #{index} / #{post_count}. #{e.message}"
          next
        end
      end
    end

    Post.reindex!
  end
  # rubocop:enable all
end
