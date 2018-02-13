# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create email: "test@test", password: "test"

user.authorities.create([
  { name: "Hello1", email: "hello1@hello.hello", website: "http://hello1.hello", password: "hello" },
  { name: "Hello2", email: "hello2@hello.hello", website: "http://hello2.hello", password: "hello" },
  { name: "Hello3", email: "hello3@hello.hello", website: "http://hello3.hello", password: "hello" },
])

p = CertProfile.create name: "(empty)"

a = user.authorities.first!
a.certificates.create(
  issuer: a,
  subject: a,
  profile: p,
  pem: "",
)
