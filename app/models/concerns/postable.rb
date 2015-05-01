module Postable
  extend ActiveSupport::Concern

  def editable?
    created_at >= 15.minutes.ago
  end

  def written_by?(membership)
    membership_id == membership.id
  end
end
