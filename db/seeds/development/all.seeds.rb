user = FactoryGirl.create(:user, :confirmed)
FactoryGirl.create_list(:group, 10)

Group.all.each do |group|
  FactoryGirl.create_list(:post, 10, group: group, user: user)
end
