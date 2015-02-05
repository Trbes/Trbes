class FakeAlgoliaSearch < Sinatra::Base
  options '/1/indexes/Group/query' do
    setup
    "{}"
  end

  post '/1/indexes/Group/query' do
    setup

    group = Group.first
    %Q{{"hits":[{"name":"#{group.name}","subdomain":"#{group.subdomain}","objectID":#{group.id}}]}}
  end

  def setup
    headers(
      "Access-Control-Allow-Origin" => "*",
      'Access-Control-Allow-Headers' => ['X-Algolia-API-Key', 'X-Algolia-Application-Id', 'Content-type']
    )
    content_type :json
  end

  def self.boot
    instance = new
    Capybara::Server.new(instance).tap { |server| server.boot }
  end
end
