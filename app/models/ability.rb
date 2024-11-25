class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: "student")

    case user.role
    when 'admin'
      can :manage, :all
    when 'teacher'
      can :manage, User, id: user.id

      can :create, Course
      can :read, Course
      can :manage, Course, teacher_id: user.id

      can :manage, Lesson, course: { teacher_id: user.id }

      can :manage, Quiz, course: { teacher_id: user.id }
      can :dashboard, Quiz, course: { teacher_id: user.id }
      can :submit, Quiz
      can :start, Quiz

      can :manage, Question, quiz: { course: { teacher_id: user.id } }

      can :manage, Payment, user_id: user.id

      can :manage, Review, student_id: user.id

      can :read, QuizParticipation, student_id: user.id
    when 'student'
      can :confirm, User
      can :manage, User, id: user.id

      can :read, Course

      can :start, Quiz
      can :submit, Quiz

      can :manage, Payment, user_id: user.id

      can :manage, Review, student_id: user.id

      can :read, QuizParticipation, student_id: user.id

      can :mark_as_watched, Lesson, course: { payments: { user_id: user.id } }
    else
      can :create, User
      can :confirm, User
      can :read, Course
      can :index_by_category, Course
    end
  end
end
