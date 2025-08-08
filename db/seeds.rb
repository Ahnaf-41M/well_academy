require "marcel"

IMG_PATH = "app/assets/images/"
DOC_PATH = "app/assets/documents/"
VID_PATH = "app/assets/videos/"

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

# Create admin user
User.create!(
  name: "Kaium Uddin",
  email: "admin@a.com",
  password: "1234",
  phone: "12345678991",
  bio: "Admin",
  role: "admin",
  confirmation_token: SecureRandom.hex(10),
  confirmed_at: Time.now,
)

# Create users and assign roles
users_data = [
  { name: "Hasib Chy", email: "hasib@welldev.io", phone: "12345678991", bio: "Demo user", role: "teacher", image: "#{IMG_PATH}hasib-bhai.jpeg" },
  { name: "Samin Al-Wasee", email: "wasee@welldev.io", phone: "12345678992", bio: "Demo user", role: "teacher", image: "#{IMG_PATH}wasee-bhai.jpeg" },
  { name: "Redwan Ahmed", email: "redwan@welldev.io", phone: "12345678993", bio: "Demo user", role: "teacher", image: "#{IMG_PATH}redwan-bhai.jpeg" },
  { name: "Arnab Saha", email: "arnab@welldev.io", phone: "12345678994", bio: "Demo user", role: "teacher", image: "#{IMG_PATH}arnab-bhai.jpeg" },
  { name: "Sadman Ahmed", email: "sadman@welldev.io", phone: "12345678995", bio: "Demo user", role: "teacher", image: "#{IMG_PATH}sadman-bhai.jpeg" },
  { name: "Kaium Uddin", email: "kaium@welldev.io", phone: "12345678996", bio: "Demo user", role: "student", image: "#{IMG_PATH}kaium-bhai.jpeg" },
  { name: "Mohammad Ashikul Islam", email: "ashik@welldev.io", phone: "12345678997", bio: "Demo user", role: "student", image: "#{IMG_PATH}ashik-bhai.jpeg" },
  { name: "Radoan Sharkar", email: "radoan@welldev.io", phone: "12345678998", bio: "Demo user", role: "student", image: "#{IMG_PATH}richi.jpeg" },
  { name: "Tahsin Turab", email: "turab@welldev.io", phone: "12345678999", bio: "Demo user", role: "student", image: "#{IMG_PATH}turab.jpeg" },
  { name: "Imtiaz Rafi", email: "rafi@welldev.io", phone: "12345678991", bio: "Demo user", role: "teacher", image: "#{IMG_PATH}rafi-bhai.jpeg" }
]

users_data.each do |user_data|
  User.create!(
    name: user_data[:name],
    email: user_data[:email],
    password: "1234",
    phone: user_data[:phone],
    bio: user_data[:bio],
    role: user_data[:role],
    confirmation_token: SecureRandom.hex(10),
    confirmed_at: Time.now,
  )
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
  { name: "Django", description: "Python Programming" },
  { name: "Elixir", description: "Elixir Programming" },
  { name: "React", description: "React Framework" },
  { name: "Angular", description: "Angular Framework" }
]

categories.each do |cat|
  Category.create!(cat)
end
puts "*** Categories table seeded successfully. ***"

# Create courses

def attach_file(record, attachment_name, file_path)
  record.public_send(attachment_name).attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: Marcel::MimeType.for(Pathname.new(file_path))
  )
end

courses_data = [
  { title: "Learn Ruby on Rails", description: "A comprehensive course on Ruby on Rails framework.", teacher: User.find_by(email: "hasib@welldev.io"), category: Category.find_by(name: "Ruby on Rails"), price: 49.99, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}ruby1.jpg", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "React JS for Beginners", description: "A comprehensive course on Ruby on Rails framework.", teacher: User.find_by(email: "hasib@welldev.io"), category: Category.find_by(name: "React"), price: 49.99, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}react.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Mastering Rails", description: "A comprehensive course on Ruby on Rails framework.", teacher: User.find_by(email: "sadman@welldev.io"), category: Category.find_by(name: "Ruby on Rails"), price: 49.99, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}ruby1.jpg", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Spring Boot 3", description: "Java Programming.", teacher: User.find_by(email: "hasib@welldev.io"), category: Category.find_by(name: "Java"), price: 84.99, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}spring-boot.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Learn Spring", description: "Java Programming.", teacher: User.find_by(email: "arnab@welldev.io"), category: Category.find_by(name: "Java"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}spring-boot.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Mastering Ruby", description: "Ruby Programming.", teacher: User.find_by(email: "arnab@welldev.io"), category: Category.find_by(name: "Ruby"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}ruby1.jpg", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Ruby on Rails", description: "Ruby Programming.", teacher: User.find_by(email: "redwan@welldev.io"), category: Category.find_by(name: "Ruby on Rails"), price: 99.99, level: 2, language: "English", duration: 0, display_picture: "#{IMG_PATH}Ruby_On_Rails_Logo.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Mastering Java", description: "Java Programming.", teacher: User.find_by(email: "redwan@welldev.io"), category: Category.find_by(name: "Java"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}Ruby_On_Rails_Logo.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Java Advanced", description: "Java Programming.", teacher: User.find_by(email: "rafi@welldev.io"), category: Category.find_by(name: "Java"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}spring-boot.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Spring Framework", description: "Spring Framework", teacher: User.find_by(email: "rafi@welldev.io"), category: Category.find_by(name: "Spring Framework"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}spring-boot.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Elixir for Everyone", description: "Elixir", teacher: User.find_by(email: "wasee@welldev.io"), category: Category.find_by(name: "Elixir"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}elixir.jpeg", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" },
  { title: "Mastering Angular", description: "Angular", teacher: User.find_by(email: "wasee@welldev.io"), category: Category.find_by(name: "Angular"), price: 75.00, level: 1, language: "English", duration: 0, display_picture: "#{IMG_PATH}angular.png", syllabus: "#{DOC_PATH}ruby-on-rails-bootcamp-syllabus.pdf", completion_certificate: "#{DOC_PATH}ruby-completion.pdf", achievement_certificate: "#{DOC_PATH}ruby-achievement.pdf" }
]

video_file_paths = Dir.glob("#{VID_PATH}**/*").select { |f| File.file?(f) }

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

  lesson = course.lessons.create!(
    title: "Lesson 1",
    order: 1
  )
  attach_file(lesson, :video, video_file_paths.sample)
end

puts "*** Courses seeded successfully! ***"
