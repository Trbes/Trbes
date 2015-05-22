require "rails_helper"

describe WeeklyDigest do
  let(:group) { create(:group, memberships: create_list(:membership, 5)) }

  it "sends emails to queue" do
    expect(SendWeeklyDigestEmailJob).to receive(:perform_later).exactly(5).times

    described_class.call
  end
end
