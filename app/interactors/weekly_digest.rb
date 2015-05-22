class WeeklyDigest
  include Interactor

  def call
    User.not_opted_out.each do |user|
      SendWeeklyDigestEmailJob.perform_later(user_id: user.id)
    end
  end
end
