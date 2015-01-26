shared_examples_for "group admin permission" do
  context "when user is group admin" do
    before do
      membership.make_admin!
    end

    it "grants access" do
      expect(subject).to permit(membership, resource)
    end
  end

  context "when user is not group admin" do
    it "denies access" do
      expect(subject).not_to permit(membership, resource)
    end
  end
end
