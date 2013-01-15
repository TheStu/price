class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.id == 1
      can :manage, :all
      can :access, :rails_admin   # grant access to rails_admin
      can :dashboard              # grant access to the dashboard
    elsif user.id.present?
      can :create, Alert
      can [:update, :destroy, :show], Alert, :user_id => user.id
      can [:update, :destroy, :show], User, :id => user.id
    end
  end
end
