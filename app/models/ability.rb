class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can [:create], [FollowingIssue, Campaign]
      can [:update, :destroy], [FollowingIssue, Campaign], :user_id => user.id
    end
  end
end
