require "rails_helper"

shared_examples_for "email about role change with correct subject and sender/receiver" do
  it "renders the subject" do
    expect(mail.subject).to eq("Your role in #{group.name} has changed")
  end

  it "renders the receiver email" do
    expect(mail.to).to eql([membership.email])
  end

  it "renders the sender email" do
    expect(mail.from).to eql(["hello@trbes.com"])
  end
end

describe MembershipMailer do
  describe "#role_changed" do
    let(:membership) { create(:membership, role: role) }
    let(:group) { membership.group }
    let(:mail) { MembershipMailer.role_changed_email(membership) }

    context "when role has changed to 'Owner'" do
      let(:role) { :owner }

      it_behaves_like "email about role change with correct subject and sender/receiver"

      it "has correct body" do
        expect(mail.body.encoded).to match("You are the new owner")
      end
    end

    context "when role has changed to 'Moderator'" do
      let(:role) { :moderator }

      it_behaves_like "email about role change with correct subject and sender/receiver"

      it "has correct body" do
        expect(mail.body.encoded).to match("has been changed to \"Moderator\"")
      end
    end

    context "when role has changed to 'Member'" do
      let(:role) { :member }

      it_behaves_like "email about role change with correct subject and sender/receiver"

      it "has correct body" do
        expect(mail.body.encoded).to match("Your membership request has been just confirmed")
      end
    end

    context "when role has changed to 'Pending'" do
      let(:role) { :pending }

      it_behaves_like "email about role change with correct subject and sender/receiver"

      it "has correct body" do
        expect(mail.body.encoded).to match("Your membership request has been sent")
      end
    end
  end
end
