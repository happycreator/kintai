# ## Admin Users
# AdminUser.create(email: 'admin1@gmail.com',
#   name:  'Admin1',
#   password: 'password',
#   password_confirmation: 'password')

# AdminUser.create(email: 'admin2@gmail.com',
#   name: 'Admin2',
#   password: 'password',
#   password_confirmation: 'password')

# ## Senior Managers
# # Main
# SeniorManager.create(email: 'sm1@gmail.com',
#   name:  'SM1_Main',
#   password:              'password',
#   password_confirmation: 'password',
#   role_code: '01',
#   line: '123456')

# # Sub
# SeniorManager.create(email: 'sm2@gmail.com',
#   name:   'SM2_Sub',
#   password:              'password',
#   password_confirmation: 'password',
#   ole_code: '02',
#   line: '654321')

## Users
User.create(name:  "User1",
email: "user1@example.com",
password:              "password",
password_confirmation: "password",
activated: true,
activated_at: Time.zone.now)

User.create(name:  "User2",
email: "user2@example.com",
password:              "password",
password_confirmation: "password",
activated: true,
activated_at: Time.zone.now)

User.create(name:  "Senior1",
  email: "senior1@example.com",
  password:              "password",
  password_confirmation: "password",
  is_senior:     true,
  activated: true,
  activated_at: Time.zone.now)

User.create(name:  "Senior2",
  email: "senior2@example.com",
  password:              "password",
  password_confirmation: "password",
  is_senior:     true,
  activated: true,
  activated_at: Time.zone.now)

User.create(name:  "Admin1",
  email: "admin1@example.com",
  password:              "password",
  password_confirmation: "password",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)

User.create(name:  "Admin2",
  email: "admin2@example.com",
  password:              "password",
  password_confirmation: "password",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)