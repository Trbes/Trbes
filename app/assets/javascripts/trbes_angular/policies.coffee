@trbes.constant 'POLICIES',
  post_display_state: "post_display_state"
  post_edit: "post_edit"
  post_destroy: "post_destroy"

@trbes.service("Authorizer", (POLICIES) ->
  return (membership) ->
    {
      policy: (policies, object) ->
        policies = [policies] unless angular.isArray(policies)
        for policy in policies
          if !POLICIES[policy]?
            throw "Bad policy value"
          switch policy
            when POLICIES.post_display_state
              return (object.state != "published" && membership && object.membership_id == membership.id) ||
                     (membership && (membership.role == "moderator" || membership.role == "owner"))
            when POLICIES.post_edit
              return membership && (membership.role == "moderator" || membership.role == "owner" || post.editable)
            when POLICIES.post_destroy
              return membership && (membership.role == "moderator" || membership.role == "owner" || post.membership_id == membership.id)
            else
              return false
        false
    }
)
