class MembershipPresenter < BasePresenter
  def show_role_overlay?
    moderator? || owner?
  end

  def role_overlay
    return unless show_role_overlay?

    h.content_tag(:span, class: "role-overlay role-overlay-#{role}") do
      role_letter
    end
  end

  def role_letter
    role[0]
  end
end
