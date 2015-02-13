RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.strategy = (example.metadata[:js] || example.metadata[:job]) ? :truncation : :transaction

    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
