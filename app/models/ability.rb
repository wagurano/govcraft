class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :create, [FollowingIssue, Campaign, Petition, Memorial]
      can [:update, :destroy], [FollowingIssue, Campaign, Petition, Memorial], :user_id => user.id
    end
  end
end
