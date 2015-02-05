class FakeAlgoliaSearch < Sinatra::Base
  options "/1/indexes/Group/query" do
    setup
    "{}"
  end

  post "/1/indexes/Group/query" do
    setup

    { hits: [] }.tap do |response|
      Group.all.each do |group|
        response[:hits] << { name: group.name, subdomain: group.subdomain, objectID: group.id }
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
    Capybara::Server.new(new).tap(&:boot)
  end
end
