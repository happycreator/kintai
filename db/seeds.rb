## Users
User.create(name:  "ユーザー1",
email: "user1@example.com",
password:              "password",
password_confirmation: "password",
activated: true,
activated_at: Time.zone.now)

User.create(name:  "ユーザー2",
email: "user2@example.com",
password:              "password",
password_confirmation: "password",
activated: true,
activated_at: Time.zone.now)

User.create(name:  "上長1",
  email: "senior1@example.com",
  password:              "password",
  password_confirmation: "password",
  is_senior:     true,
  activated: true,
  activated_at: Time.zone.now)

User.create(name:  "上長2",
  email: "senior2@example.com",
  password:              "password",
  password_confirmation: "password",
  is_senior:     true,
  activated: true,
  activated_at: Time.zone.now)

User.create(name:  "管理者1",
  email: "admin1@example.com",
  password:              "password",
  password_confirmation: "password",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)

User.create(name:  "管理者2",
  email: "admin2@example.com",
  password:              "password",
  password_confirmation: "password",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)