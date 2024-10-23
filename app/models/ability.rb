class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new(role: "student")
    # These methods (admin?, user?) are typically defined in the User model, either manually or through an enum
    if user.admin?
      can :manage, :all
    elsif user.teacher?

      can :read, User
      can :create, User
      can :update, User, id: user.id
      can :destroy, User, id: user.id
      can :confirm, User

      can :read, Course
      can :create, Course
      can :update, Course, id: course.id
      can :destroy, Course, id: course.id

    elsif user.student?
      can :become_teacher, User
      can :read, Course
      can :read, User
      can :create, User
      can :edit, User
      can :update, User, id: user
      can :destroy, User, id: user.id
      can :confirm, User
    else
      can :read, :all
      can :create, User
      can :confirm, User
    end
  end
end
