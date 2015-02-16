RSpec.configure do |config|
  config.before(:each) do |example|
    if example.metadata[:js] || example.metadata[:job]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
