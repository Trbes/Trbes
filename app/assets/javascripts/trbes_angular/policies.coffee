@trbes.constant 'POLICIES',
  post_display_state: "post_display_state"

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
            else
              return false
        false
    }
)
