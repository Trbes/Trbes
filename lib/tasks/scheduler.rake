task weekly_digest: :environment do
  puts "Adding emails to weekly digest queue..."
  Group.all.each do |group|
    group.memberships.not_pending.each do |membership|
      SendWeeklyDigestJob.perform_later(membership_id: membership.id)
    end
  end
  puts "Adding to queue finished."
end
