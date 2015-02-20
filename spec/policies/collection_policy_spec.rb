require "rails_helper"

describe CollectionPolicy do
  subject { described_class }

  %i(create update destroy).each do |action|
    permissions "#{action}?".to_sym do
      it_behaves_like "group owner permission" do
        let(:membership) { create(:membership) }
        let(:resource) { Collection.new }
      end
    end
  end
end
