class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :social_card], :all
    can [:events], Campaign
    can :create, [Sign, Comment, Like]

    if user
      can :create, [
          FollowingIssue,
          Campaign, Discussion, Petition, Poll, Wiki,
          Memorial, Agenda, Archive, ArchiveDocument, Event,
          Election, Candidate
        ]
      can [:update, :destroy], [
          FollowingIssue,
          Campaign, Discussion, Petition, Poll, Wiki,
          Memorial, Agenda, Archive, ArchiveDocument, Event,
          Comment, Sign, Election, Candidate
        ], :user_id => user.id

      can :data, [Petition], user_id: user.id

      # 모든 당원은 위키를 수정하고 원복할 수 있다
      can [:update], Wiki
      can [:revert], WikiRevision

      # 캠페이너는 캠페인에 속한 글과 댓글을 삭제할 수 있다
      can :destroy, [Discussion, Petition, Poll, Wiki, Event] do |model|
        model.campaign && user == model.campaign.user
      end
      can :destroy, Comment do |comment|
        comment.commentable.try(:campaign) && user == comment.commentable.campaign.user
      end

      if user.has_role? :admin
        can :manage, :all
      end
    end
  end
end
