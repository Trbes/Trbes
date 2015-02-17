shared_examples_for "group owner permission" do
  context "when user is group owner" do
    before do
      membership.owner!
    end

    it "grants access" do
      expect(subject).to permit(membership, resource)
    end
  end

  context "when user is not group owner" do
    it "denies access" do
      expect(subject).not_to permit(membership, resource)
    end
  end
end
