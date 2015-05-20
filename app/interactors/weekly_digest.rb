class WeeklyDigest
  include Interactor

  def call
    Group.all.each do |group|
      group.memberships.not_pending.each do |membership|
        SendWeeklyDigestEmailJob.perform_later(membership_id: membership.id)
      end
    end
  end
end
