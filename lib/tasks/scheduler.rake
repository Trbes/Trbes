namespace :scheduler do
  task weekly_digest: :environment do
    puts "Adding emails to weekly digest queue..."

    WeeklyDigest.call if Time.now.thursday?

    puts "Adding to queue finished."
  end
end
