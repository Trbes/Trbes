require 'rails_helper'

describe Group do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:subdomain) }
    it 'should have a valid subdomain' do
      expect(build(:group, subdomain: 'www')).not_to be_valid
      expect(build(:group, subdomain: 'speci@l')).not_to be_valid
      expect(build(:group, subdomain: 'normal')).to be_valid
    end
  end
end
