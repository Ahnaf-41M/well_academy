class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: "student")
    # These methods (admin?, user?) are typically defined in the User model, either manually or through an enum
    if user.admin?
      can :manage, :all
    elsif user.teacher?

      can :read, User, id: user.id
      can :create, User
      can :update, User, id: user.id
      can :destroy, User, id: user.id
      can :confirm, User
      can :remove_profile_picture, User

      can :read, Course
      can :create, Course
      can :update, Course
      can :destroy, Course

      can :read, Lesson
      can :create, Lesson
      can :update, Lesson
      can :destroy, Lesson

    elsif user.student?
      can :become_teacher, User
      can :read, Course
      can :read, User, id: user.id
      can :create, User
      can :edit, User, id: user.id
      can :update, User, id: user.id
      can :destroy, User, id: user.id
      can :confirm, User
      can :remove_profile_picture, User
    else
      can :read, :all
      cannot :read, User
      can :create, User
      can :confirm, User
    end
  end
end
