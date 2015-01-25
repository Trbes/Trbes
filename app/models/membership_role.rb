class MembershipRole < ActiveRecord::Base
  belongs_to :membership, required: true
  belongs_to :role, required: true
end
