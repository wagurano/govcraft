class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all

    if user
      can :create, [FollowingIssue, Campaign, Discussion, Petition, Poll, Memorial, Agenda, Comment, Like]
      can [:update, :destroy], [FollowingIssue, Campaign, Discussion, Petition, Poll, Memorial, Agenda, Comment, Like], :user_id => user.id
    end
  end
end
