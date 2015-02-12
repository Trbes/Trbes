require "rails_helper"

describe AccessPolicy do
  subject { described_class }

  permissions :admin? do
    it_behaves_like "group admin permission" do
      let(:membership) { create(:membership) }
      let(:resource) { Collection.new }
    end
  end
end
