OmniAuth.config.test_mode = true

OmniAuth.config.add_mock(:twitter, {
  provider: "twitter",
  uid: "12345",
  info: { nickname: "name" },
  extra: { raw_info: { name: "name" } }
})

OmniAuth.config.add_mock(:facebook, {
  provider: "facebook",
  uid: "12345",
  info: { email: "user@example.com" },
  extra: { raw_info: { name: "name" } }
})

OmniAuth.config.add_mock(:google_oauth2, {
  provider: "google_oauth2",
  uid: "12345",
  info: { email: "user@example.com" },
  extra: { raw_info: { name: "name" } }
})

OmniAuth.config.add_mock(:linkedin, {
  provider: "linkedin",
  uid: "12345",
  info: {
    email: "user@example.com",
    name: "name"
  },
  extra: { raw_info: { name: "name" } }
})
