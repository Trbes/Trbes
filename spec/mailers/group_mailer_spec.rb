require "rails_helper"

describe GroupMailer do
  let!(:group) { create(:group) }
  let(:membership) { create(:membership, group: group) }
  let(:posts) { create_list(:post, 5, group: group, membership: membership) }

  let(:mail) { described_class.weekly_digest_email(membership) }

  describe "#weekly_digest_email" do
    context "when there are new posts" do
      it "contains posts titles" do
        posts.each do |post|
          expect(mail.body.encoded).to include(post.title)
        end
      end
    end

    context "when there are no new posts" do
      before do
        Post.update_all(created_at: 2.weeks.ago)
      end

      it "contains link to site" do
        expect(mail.body.encoded).to include("There are no new posts in the past week")
        expect(mail.body.encoded).to include("http://#{group.subdomain}.#{DEFAULT_HOST}")
      end
    end
  end
end
