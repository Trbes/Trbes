require "rails_helper"

describe GroupMailer do
  let!(:group) { create(:group) }
  let(:membership) { create(:membership, group: group) }
  let(:posts) { create_list(:post, 5, group: group, membership: membership) }

  let(:mail) { described_class.weekly_digest_email(membership) }

  describe "#weekly_digest_email" do
    it "contains posts titles" do
      posts.each do |post|
        expect(mail.body.encoded).to include(post.title)
      end
    end
  end
end
