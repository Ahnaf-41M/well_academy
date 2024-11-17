User.destroy_all
puts "*** Database cleared. ***"

def attach_local_image(record, attachment_name, local_path)
  file = File.open(local_path)
  record.send(attachment_name).attach(
    io: file,
    filename: File.basename(local_path),
    content_type: 'image/jpeg'
  )
  file.close
end

User.create!(
  name: "Kaium Uddin",
  email: "admin@a.com",
  password: "1234",
  phone: "1234567890",
  bio: "Admin",
  role: "admin"
)

user = User.create!(name: "Hasib Chy", email: "hasib@welldev.io", password: "1234", phone: "1234567891", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/hasib-bhai.jpeg")
user = User.create!(name: "Samin Al-Wasee", email: "wasee@welldev.io", password: "1234", phone: "1234567892", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/wasee-bhai.jpeg")
user = User.create!(name: "Redwan Ahmed", email: "redwan@welldev.io", password: "1234", phone: "1234567893", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/redwan-bhai.jpeg")
user = User.create!(name: "Arnab Saha", email: "arnab@welldev.io", password: "1234", phone: "1234567894", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/arnab-bhai.jpeg")
user = User.create!(name: "Sadman Ahmed", email: "sadman@welldev.io", password: "1234", phone: "1234567894", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/sadman-bhai.jpeg")
user = User.create!(name: "Kaium Uddin", email: "kaium@welldev.io", password: "1234", phone: "1234567894", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/kaium-bhai.jpeg")
user = User.create!(name: "Mohammad Ashikul Islam", email: "ashik@welldev.io", password: "1234", phone: "1234567894", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/ashik-bhai.jpeg")
user = User.create!(name: "Radoan Sharkar", email: "radoan@welldev.io", password: "1234", phone: "1234567894", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/richi.jpeg")
user = User.create!(name: "Tahsin Turab", email: "turab@welldev.io", password: "1234", phone: "1234567894", bio: "Demo user", role: "student")
attach_local_image(user, :profile_picture, "/Users/ahnaf/Documents/GitHub/well_academy/app/assets/images/turab.jpeg")

puts "*** Database created. ***"
