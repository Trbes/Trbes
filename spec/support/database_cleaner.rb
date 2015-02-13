RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    # return if example.metadata[:sucker_punch]

    DatabaseCleaner.strategy = (example.metadata[:js] || example.metadata[:job]) ? :truncation : :transaction

    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
