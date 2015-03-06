class FakeAlgoliaSearch < Sinatra::Base
  options "/1/indexes/Group_test/query" do
    setup
    "{}"
  end

  post "/1/indexes/Group_test/query" do
    setup

    { hits: [] }.tap do |response|
      Group.all.each do |group|
        response[:hits] << { name: group.name, subdomain: group.subdomain, objectID: group.id }
      end
    end.to_json
  end

  options "/1/indexes/Post_test/query" do
    setup
    "{}"
  end

  post "/1/indexes/Post_test/query" do
    setup

    { hits: [] }.tap do |response|
      Post.all.each do |post|
        response[:hits] << { title: post.title, slug: post.slug, objectID: post.id, _tags: ["group_#{post.group_id}"] }
      end
    end.to_json
  end

  def setup
    headers(
      "Access-Control-Allow-Origin" => "*",
      "Access-Control-Allow-Headers" => ["X-Algolia-API-Key", "X-Algolia-Application-Id", "Content-type"]
    )
    content_type :json
  end

  def self.boot
    Capybara::Server.new(new, 4567).tap(&:boot)
  end
end

server = FakeAlgoliaSearch.boot
ALGOLIA_HOSTS = [[server.host, server.port].join(":")]
