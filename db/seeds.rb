User.destroy_all
puts "*** Database cleared. ***"

# Attach local image helper
def attach_local_image(record, attachment_name, local_path)
  file_path = Rails.root.join(local_path)
  unless File.exist?(file_path)
    puts "Image not found: #{file_path}, skipping attachment."
    return
  end
  file = File.open(file_path)
  record.send(attachment_name).attach(
    io: file,
    filename: File.basename(local_path),
    content_type: 'image/jpeg'
  )
  file.close
end

# Create admin user
admin = User.create!(
  name: "Kaium Uddin",
  email: "admin@a.com",
  password: "1234",
  phone: "12345678991",
  bio: "Admin",
  role: "admin"
)
puts "Admin user created."

# Create users and assign roles
users_data = [
  { name: "Hasib Chy", email: "hasib@welldev.io", phone: "12345678991", bio: "Demo user", role: "teacher", image: "app/assets/images/hasib-bhai.jpeg" },
  { name: "Samin Al-Wasee", email: "wasee@welldev.io", phone: "12345678992", bio: "Demo user", role: "student", image: "app/assets/images/wasee-bhai.jpeg" },
  { name: "Redwan Ahmed", email: "redwan@welldev.io", phone: "12345678993", bio: "Demo user", role: "teacher", image: "app/assets/images/redwan-bhai.jpeg" },
  { name: "Arnab Saha", email: "arnab@welldev.io", phone: "12345678994", bio: "Demo user", role: "teacher", image: "app/assets/images/arnab-bhai.jpeg" },
  { name: "Sadman Ahmed", email: "sadman@welldev.io", phone: "12345678995", bio: "Demo user", role: "student", image: "app/assets/images/sadman-bhai.jpeg" },
  { name: "Kaium Uddin", email: "kaium@welldev.io", phone: "12345678996", bio: "Demo user", role: "student", image: "app/assets/images/kaium-bhai.jpeg" },
  { name: "Mohammad Ashikul Islam", email: "ashik@welldev.io", phone: "12345678997", bio: "Demo user", role: "student", image: "app/assets/images/ashik-bhai.jpeg" },
  { name: "Radoan Sharkar", email: "radoan@welldev.io", phone: "12345678998", bio: "Demo user", role: "student", image: "app/assets/images/richi.jpeg" },
  { name: "Tahsin Turab", email: "turab@welldev.io", phone: "12345678999", bio: "Demo user", role: "student", image: "app/assets/images/turab.jpeg" },
  { name: "Imtiaz Rafi", email: "rafi@welldev.io", phone: "12345678991", bio: "Demo user", role: "student", image: "app/assets/images/rafi-bhai.jpeg" },
]

users_data.each do |user_data|
  user = User.create!(
    name: user_data[:name],
    email: user_data[:email],
    password: "1234",
    phone: user_data[:phone],
    bio: user_data[:bio],
    role: user_data[:role]
  )
  attach_local_image(user, :profile_picture, user_data[:image])

  puts "User #{user.name} created with role: #{user.role}."
end

puts "*** Database seeded successfully. ***"
