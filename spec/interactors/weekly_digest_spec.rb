require "rails_helper"

describe WeeklyDigest do
  let(:group) { create(:group, memberships: create_list(:membership, 5)) }

  context "for confirmed group members" do
    before do
      group.memberships.update_all(role: "member")
    end

    it "sends emails to queue" do
      expect(SendWeeklyDigestEmailJob).to receive(:perform_later).exactly(5).times

      described_class.call
    end
  end

  context "for pending group members" do
    before do
      group.memberships.limit(3).update_all(role: "pending")
    end

    it "doesn't send emails to queue" do
      expect(SendWeeklyDigestEmailJob).to receive(:perform_later).exactly(3).times

      described_class.call
    end
  end
end
