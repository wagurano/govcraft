class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can [:create], FollowingIssue
      can [:destroy], FollowingIssue, :user_id => user.id
    end
  end
end
