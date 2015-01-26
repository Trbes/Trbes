shared_examples_for "every user permission" do
  it "grants access" do
    expect(subject).to permit(membership, resource)
  end
end
