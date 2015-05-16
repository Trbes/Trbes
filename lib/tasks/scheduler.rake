namespace :scheduler do
  task weekly_digest: :environment do
    puts "Adding emails to weekly digest queue..."

    WeeklyDigest.call

    puts "Adding to queue finished."
  end
end
