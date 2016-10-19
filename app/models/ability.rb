class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :create, [FollowingIssue, Campaign, Petition]
      can [:update, :destroy], [FollowingIssue, Campaign, Petition], :user_id => user.id
    end
  end
end
