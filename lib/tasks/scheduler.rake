namespace :scheduler do
  task weekly_digest: :environment do
    puts "Adding emails to weekly digest queue..."

    if Time.now.thursday?
      WeeklyDigest.call
    end

    puts "Adding to queue finished."
  end
end
