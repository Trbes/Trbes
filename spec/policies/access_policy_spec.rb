require "rails_helper"

describe AccessPolicy do
  subject { described_class }

  permissions :admin_access? do
    it_behaves_like "group owner permission" do
      let(:membership) { create(:membership) }
      let(:resource) { Collection.new }
    end
  end
end
