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

    group.add_member user, as: :owner
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
          if %w(
              2012/07/tous-les-articles/
              2012/07/page-daccueil/
              2012/07/contact-form-1/
            ).include? post_slug
            p "SKIPPED --> #{index} / #{post_count}."
            next
          end

          if post_data["post_title"].blank?
            p "SKIPPED --> #{index} / #{post_count}."
            next
          end

          post_body = post_data["post_content"] || ""
          post_body.gsub!(%r{(https|http)://(blog.)+webdepart.com/wp-content/uploads/}, "http://archive.webdepart.com/files/wd/")
          post_body.gsub!("\n", "<br>")
          author = users.select{ |u| u["ID"] == post_data["post_author"] }.first
          meta_text = "ORIGINALLY PUBLISHED: #{post_date}"
          meta_text += (author ? " BY #{author['display_name'].upcase}." : ".")
          post_body = "<em>#{meta_text}</em><br><br>" + post_body
          post_time = Time.parse(post_data["post_date_gmt"] + " UTC")

          result = CreatePost.call(
            attributes: {
              title: post_data["post_title"].html_safe.html_safe,
              body: post_body,
              post_type: :text_post,
              slug: post_slug,
              created_at: post_time
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

  task import_mtw: :environment do
    require "crack"

    user = User.find_by email: "archive@montrealtechwatch.com"

    user = User.create(
      email: "archive@montrealtechwatch.com",
      full_name: "Montreal Tech Watch",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.now
    ) unless user
    p "fetched user #{user}"

    group = Group.find_by subdomain: "mtw"

    group = Group.create(
      name: "Montreal Tech Watch",
      tagline: "The MTW archive",
      private: false,
      subdomain: "mtw"
    ) unless group
    p "fetched group #{group}"

    group.add_member user, as: :owner
    p "added user to group"

    data = Crack::XML.parse File.read("#{Rails.root}/db/data/mtw.xml")
    p "parsed data file"

    posts = data['mtw']['mtw_posts']['row']
    users = data['mtw']['mtw_users']['row']
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

          if post_data["post_title"].blank?
            p "SKIPPED --> #{index} / #{post_count}."
            next
          end

          post_body = post_data["post_content"] || ""
          post_body.gsub!(%r{(https|http)://montrealtechwatch.com/(wp-content/uploads|images)/}, "http://archive.montrealtechwatch.com/files/mtw/")
          post_body.gsub!("\n", "<br>")
          author = users.select{ |u| u["ID"] == post_data["post_author"] }.first

          meta_text = "ORIGINALLY PUBLISHED: #{post_date}"
          meta_text += (author ? " BY #{author['display_name'].upcase}." : ".")
          post_body = "<em>#{meta_text}</em><br><br>" + post_body
          post_time = Time.parse(post_data["post_date_gmt"] + " UTC")

          result = CreatePost.call(
            attributes: {
              title: post_data["post_title"].html_safe.html_safe,
              body: post_body,
              post_type: :text_post,
              slug: post_slug,
              created_at: post_time
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
