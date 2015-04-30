@trbes.constant 'POLICIES',
  post_display_state: "post_display_state"
  post_edit: "post_edit"
  post_destroy: "post_destroy"
  collection_post_create: "collection_post_create"
  collection_post_create_for: "collection_post_create_for"
  collection_post_destroy: "collection_post_destroy"
  collection_create: "collection_create"

@trbes.service("Authorizer", (POLICIES) ->
  return (membership) ->
    {
      policy: (policies, object) ->
        policies = [policies] unless angular.isArray(policies)
        for policy in policies
          if !POLICIES[policy]?
            throw "Bad policy value"
          switch policy
            # Post policies
            when POLICIES.post_display_state
              return (object.state != "published" && membership && object.membership_id == membership.id) ||
                       (membership && (membership.role == "moderator" || membership.role == "owner"))
            when POLICIES.post_edit
              return membership && (membership.role == "moderator" || membership.role == "owner" || post.editable)
            when POLICIES.post_destroy
              return membership && (membership.role == "moderator" || membership.role == "owner" || post.membership_id == membership.id)

            # Collection post policies
            when POLICIES.collection_post_create
              return membership && (membership.role == "moderator" || membership.role == "owner")
            when POLICIES.collection_post_create_for
              post = object[0]
              available_collections = object[1] || []
              return membership && (membership.role == "moderator" || membership.role == "owner") &&
                       available_collections.length && !post.collection_posts.length
            when POLICIES.collection_post_destroy
              return membership && (membership.role == "moderator" || membership.role == "owner")

            # Collection policies
            when POLICIES.collection_create
              return membership && (membership.role == "moderator" || membership.role == "owner")

            else
              return false
        false
    }
)