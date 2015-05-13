task weekly_digest: :environment do
  puts "Adding emails to weekly digest queue..."

  SendWeeklyDigest.call

  puts "Adding to queue finished."
end
