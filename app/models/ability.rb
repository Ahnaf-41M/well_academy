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
      can :manage, Payment, user_id: user.id
      can :manage, Review, student_id: user.id
    when 'student'
      can :manage, User, id: user.id
      can :read, Course
      can :confirm, User
      can :manage, Payment, user_id: user.id
      can :manage, Review, student_id: user.id
    else
      can :create, User
      can :confirm, User
      can :read, Course
      can :index_by_category, Course
    end
  end
end
