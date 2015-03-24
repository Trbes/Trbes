module ControllerHelpers
  def stub_auth
    stub_current_user
    stub_current_membership
    stub_current_group
  end

  def stub_current_user
    user = create(:user)
    allow(controller).to receive(:current_user).and_return(user)
    allow_message_expectations_on_nil
    allow(request.env["warden"]).to receive(:authenticate!).and_return(user)
  end

  def stub_current_membership
    membership = double("membership", owner?: true, user: create(:user))
    allow(controller).to receive(:current_membership).and_return(membership)
  end

  def stub_current_group
    group = create(:group)
    allow(controller).to receive(:current_group).and_return(group)
  end
end
