class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :create, [FollowingIssue, Campaign, Discussion, Petition, Memorial, Comment]
      can [:update, :destroy], [FollowingIssue, Campaign, Discussion, Petition, Memorial], :user_id => user.id
    end
  end
end
