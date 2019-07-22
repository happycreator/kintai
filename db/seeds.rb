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
User.create(email: 'user1@gmail.com',
name:  'User1',
password:              'password',
password_confirmation: 'password',
# service_id: 1,

User.create(email: 'user2@gmail.com',
name:  'User2',
password: "password",
password_confirmation: 'password',
#service_id: 1,

User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  admin:     true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end