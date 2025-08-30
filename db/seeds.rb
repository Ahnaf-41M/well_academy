User.destroy_all
puts "*** User table cleared. ***"
ActiveStorage::Attachment.all.each do |attachment|
  attachment.purge
end
ActiveStorage::Blob.find_each do |blob|
  blob.purge
end
puts "*** All ActiveStorage attachments and blobs cleared. ***"

Category.destroy_all
puts "*** Categories table cleared. ***"

# Attach local image helper
def attach_local_image(record, attachment_name, local_path)
  file_path = Rails.root.join(local_path)
  unless File.exist?(file_path)
    puts "Image not found: #{file_path}, skipping attachment."
    return
  end
  file = File.open(file_path)
  extension = File.extname(local_path).downcase
  content_type = case extension
  when '.jpg', '.jpeg'
                   'image/jpeg'
  when '.png'
                   'image/png'
  else
                   'application/octet-stream' # Fallback if file is not recognized
  end

  # Attach the file to the record
  record.send(attachment_name).attach(
    io: file,
    filename: File.basename(local_path),
    content_type: content_type
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
  { name: "Imtiaz Rafi", email: "rafi@welldev.io", phone: "12345678991", bio: "Demo user", role: "teacher", image: "app/assets/images/rafi-bhai.jpeg" }
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
end

puts "*** User table seeded successfully. ***"

# categories
categories = [
  { name: "Ruby", description: "Ruby is an interpreted, high-level, general-purpose programming language. It was designed with an emphasis on programming productivity and simplicity. In Ruby, everything is an object, including primitive data types. It was developed in the mid-1990s by Yukihiro 'Matz' tsumoto in Japan." },
  { name: "Ruby on Rails", description: "Ruby on Rails (simplified as Rails) is a server-side web application framework written in Ruby under the MIT License. Rails is a model–view–controller (MVC) framework, providing default structures for a database, a web service, and web pages." },
  { name: "Java", description: "Java Programming" },
  { name: "Spring Framework", description: "Java Programming" },
  { name: "C#", description: "C# Programming" },
  { name: ".NET with C#", description: "C# Programming" },
  { name: "Python", description: "Python Programming" },
  { name: "Django", description: "Python Programming" }
]

categories.each do |cat|
  Category.create!(cat)
end
puts "*** Categories table seeded successfully. ***"

# Attach files helper
def attach_file(record, attachment_name, file_path)
  file = Rails.root.join(file_path)
  if File.exist?(file)
    record.send(attachment_name).attach(
      io: File.open(file),
      filename: File.basename(file_path),
      content_type: Mime::Type.lookup_by_extension(File.extname(file_path).delete('.')).to_s
    )
  else
    puts "File not found: #{file_path}, skipping attachment."
  end
end

# Create courses
courses_data = [
  { title: "Learn Ruby on Rails", description: "A comprehensive course on Ruby on Rails framework.", teacher: User.find_by(email: "hasib@welldev.io"), category: Category.find_by(name: "Ruby on Rails"), price: 49.99, level: 1, language: "English", duration: 0, display_picture: "app/assets/images/ruby1.jpg", syllabus: "app/assets/documents/ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "app/assets/documents/ruby-completion.pdf", achievement_certificate: "app/assets/documents/ruby-achievement.pdf" },
  { title: "Spring Boot 3", description: "Java Programming.", teacher: User.find_by(email: "hasib@welldev.io"), category: Category.find_by(name: "Java"), price: 84.99, level: 1, language: "English", duration: 0, display_picture: "app/assets/images/spring-boot.png", syllabus: "app/assets/documents/ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "app/assets/documents/ruby-completion.pdf", achievement_certificate: "app/assets/documents/ruby-achievement.pdf" },
  { title: "Learn Spring", description: "Java Programming.", teacher: User.find_by(email: "arnab@welldev.io"), category: Category.find_by(name: "Java"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "app/assets/images/spring-boot.png", syllabus: "app/assets/documents/ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "app/assets/documents/ruby-completion.pdf", achievement_certificate: "app/assets/documents/ruby-achievement.pdf" },
  { title: "Mastering Ruby", description: "Ruby Programming.", teacher: User.find_by(email: "arnab@welldev.io"), category: Category.find_by(name: "Ruby"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "app/assets/images/ruby1.jpg", syllabus: "app/assets/documents/ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "app/assets/documents/ruby-completion.pdf", achievement_certificate: "app/assets/documents/ruby-achievement.pdf" },
  { title: "Ruby on Rails", description: "Ruby Programming.", teacher: User.find_by(email: "redwan@welldev.io"), category: Category.find_by(name: "Ruby on Rails"), price: 99.99, level: 2, language: "English", duration: 0, display_picture: "app/assets/images/Ruby_On_Rails_Logo.png", syllabus: "app/assets/documents/ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "app/assets/documents/ruby-completion.pdf", achievement_certificate: "app/assets/documents/ruby-achievement.pdf" },
  { title: "Mastering Java", description: "Java Programming.", teacher: User.find_by(email: "redwan@welldev.io"), category: Category.find_by(name: "Java"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "app/assets/images/Ruby_On_Rails_Logo.png", syllabus: "app/assets/documents/ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "app/assets/documents/ruby-completion.pdf", achievement_certificate: "app/assets/documents/ruby-achievement.pdf" }
]

courses_data.each do |course_data|
  course = Course.create!(
    title: course_data[:title],
    description: course_data[:description],
    teacher: course_data[:teacher],
    category: course_data[:category],
    price: course_data[:price],
    level: course_data[:level],
    language: course_data[:language],
    duration: course_data[:duration]
  )

  attach_file(course, :display_picture, course_data[:display_picture])
  attach_file(course, :syllabus, course_data[:syllabus])
  attach_file(course, :completion_certificate, course_data[:completion_certificate])
  attach_file(course, :achievement_certificate, course_data[:achievement_certificate])
end

puts "*** Courses seeded successfully! ***"
