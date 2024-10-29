# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: "student")

    case user.role
    when 'admin'
      can :manage, :all
    when 'teacher'
      can :manage, User, id: user.id
      can :manage, Course, teacher_id: user.id
      can :create, Course
      can :read, Course
      can :manage, Lesson, course: { teacher_id: user.id }
      can :create, Lesson
      can :read, Lesson
    when 'student'
      can :manage, User, id: user.id
      can :read, Course
      can :confirm, User
    else
      can :create, User
      can :confirm, User
    end
  end
end
