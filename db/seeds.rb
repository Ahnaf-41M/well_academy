require 'faker'
require 'dotenv/load'  # Loads API keys from .env
require 'httparty'
require 'open-uri'
require 'mime/types'
require 'mini_magick'

# Clear tables
tables = ActiveRecord::Base.connection.tables - [ 'schema_migrations', 'ar_internal_metadata' ]
ActiveRecord::Base.connection.execute("TRUNCATE #{tables.join(', ')} RESTART IDENTITY CASCADE")

puts "✅ Database cleared."

ROLES = %w[teacher student]
CATEGORIES = %w[Ruby Rails Java Spring C# .NET Python Django NodeJs]

PROFILE_PIC_PATHS = [
  Rails.root.join("public/images/profile_pictures/bill_gates.jpg"),
  Rails.root.join("public/images/profile_pictures/elon_musk.jpg"),
  Rails.root.join("public/images/profile_pictures/zuckerberg.jpg")
]

COURSE_PIC_PATHS = [
  Rails.root.join("public/images/course_pictures/ror1.png"),
  Rails.root.join("public/images/course_pictures/ror2.png"),
  Rails.root.join("public/images/course_pictures/ror3.jpeg"),
  Rails.root.join("public/images/course_pictures/spring1.png"),
  Rails.root.join("public/images/course_pictures/spring2.jpg"),
  Rails.root.join("public/images/course_pictures/spring3.jpg")
]

VIDEO_PATHS = [
  Rails.root.join("public/videos/1. Introduction to Algorithms.mp4"),
  Rails.root.join("public/videos/1.1 Priori Analysis and Posteriori Testing.mp4"),
  Rails.root.join("public/videos/Full Stack Ruby on Rails Development Bootcamp.mp4"),
  Rails.root.join("public/videos/Part 1 - C# Tutorial - Introduction.avi.mp4"),
  Rails.root.join("public/videos/What is Spring Boot in Hindi _ The Whys and Hows of this Java Marvel!.mp4")
]

ACHIEVEMENT_CERTIFICATE_PATHS = [
  "public/files/course_syllabus/dsa/datastructures-and-algorithms.pdf",
  "public/files/course_syllabus/dsa/DSA syllabus.pdf",
  "public/files/course_syllabus/dsa/DSA-2013-Syllabus.pdf",
  "public/files/course_syllabus/dsa/SevenMentor-Data-Structures-and-Algorithms-with-Java-Course-in-Pune-Syllabus.pdf"
]

COURSE_SYLLABUS_PATHS = [
  Rails.root.join("public/files/course_syllabus/dsa/datastructures-and-algorithms.pdf"),
  Rails.root.join("public/files/course_syllabus/dsa/DSA syllabus.pdf"),
  Rails.root.join("public/files/course_syllabus/dsa/DSA-2013-Syllabus.pdf"),
  Rails.root.join("public/files/course_syllabus/dsa/SevenMentor-Data-Structures-and-Algorithms-with-Java-Course-in-Pune-Syllabus.pdf"),
  Rails.root.join("public/files/course_syllabus/java/LearnJava.pdf"),
  Rails.root.join("public/files/course_syllabus/java/M.C.A. (Sem - IV)- Java Programming.pdf"),
  Rails.root.join("public/files/course_syllabus/java/SevenMentor-Java-Fullstack-Syllabus.pdf"),
  Rails.root.join("public/files/course_syllabus/java/Syllabus_Core_Java_and_Advanced_Java .pdf"),
  Rails.root.join("public/files/course_syllabus/nodejs/57-Node_JS.pdf"),
  Rails.root.join("public/files/course_syllabus/nodejs/1587740047.pdf"),
  Rails.root.join("public/files/course_syllabus/nodejs/Node-JS-Course-Content.pdf")
]
# Create admin user
User.create!(
  name: 'Ahnaf Chowdhury',
  email: 'admin@a.com',
  password: 'admin',
  phone: "01#{Faker::Number.number(digits: 9)}",
  bio: 'Admin',
  role: 'admin'
)

# Create users dynamically with Pexels images
def find_content_type(extension)
  case extension.downcase
  when 'jpg', 'jpeg'       then 'image/jpeg'
  when 'png'               then 'image/png'
  when 'gif'               then 'image/gif'
  when 'webp'              then 'image/webp'
  when 'svg'               then 'image/svg+xml'

  when 'mp4'               then 'video/mp4'
  when 'mov'               then 'video/quicktime'
  when 'avi'               then 'video/x-msvideo'
  when 'mkv'               then 'video/x-matroska'
  when 'webm'              then 'video/webm'

  when 'pdf'               then 'application/pdf'
  when 'doc'               then 'application/msword'
  when 'docx'              then 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  when 'txt'               then 'text/plain'
  when 'csv'               then 'text/csv'
  when 'json'              then 'application/json'
  else 'application/octet-stream'  # Generic fallback
  end
end


def attach_remote_file(record, attachment_name, file_path)
  extension = File.extname(file_path).delete('.').downcase
  record.send(attachment_name).attach(
    io: File.open(file_path),
    filename: File.basename(file_path),
    content_type: find_content_type(extension)
  )
end

10.times do |i|
  user = User.create!(
    name: Faker::Name.name,
    email: "user#{i}@gmail.com",
    password: '1234',
    phone: "01#{Faker::Number.number(digits: 9)}",
    bio: Faker::Lorem.sentence(word_count: 5),
    role: ROLES.sample
  )

  image_url = PROFILE_PIC_PATHS.sample
  attach_remote_file(user, :profile_picture, image_url)
end
puts "✅ Users seeded successfully!"

# Create categories dynamically
CATEGORIES.each do |category|
  Category.create!(
    name: category,
    description: Faker::Lorem.paragraph(sentence_count: 3)
  )
end
puts "***✅ Categories seeded successfully! ***"

# Create courses dynamically with images & videos
3.times do
  course = Course.create!(
    title: Faker::Educator.course_name,
    description: Faker::Lorem.paragraph(sentence_count: 5),
    teacher: User.where(role: 'teacher').sample,
    category: Category.all.sample,
    price: rand(30..100),
    level: rand(1..3),
    language: 'English',
    duration: rand(5..50)
  )

  attach_remote_file(course, :display_picture, COURSE_PIC_PATHS.sample)
  attach_remote_file(course, :syllabus, COURSE_SYLLABUS_PATHS.sample)
  attach_remote_file(course, :completion_certificate, ACHIEVEMENT_CERTIFICATE_PATHS.sample)
  attach_remote_file(course, :achievement_certificate, ACHIEVEMENT_CERTIFICATE_PATHS.sample)

  3.times do |i|
    lesson = Lesson.create!(
      course: course,
      title: Faker::Educator.course_name,
      order: i+1
    )
    attach_remote_file(lesson, :content, ACHIEVEMENT_CERTIFICATE_PATHS.sample)
    attach_remote_file(lesson, :video, VIDEO_PATHS.sample)
  end
end

puts "✅ Courses seeded successfully!"
