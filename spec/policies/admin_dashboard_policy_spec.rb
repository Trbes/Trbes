require "rails_helper"

describe AdminDashboardPolicy do
  subject { described_class }

  permissions :index? do
    it_behaves_like "group admin permission" do
      let(:membership) { create(:membership) }
      let(:resource) { Collection.new }
    end
  end
end
