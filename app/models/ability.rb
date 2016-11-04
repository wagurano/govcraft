class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :social_card], :all
    can :create, [Sign, Comment]

    if user
      can :create, [
          FollowingIssue,
          Campaign, Discussion, Petition, Poll, Wiki,
          Memorial, Agenda, Archive, ArchiveDocument,
          Like
        ]
      can [:update, :destroy], [
          FollowingIssue,
          Campaign, Discussion, Petition, Poll, Wiki,          Memorial, Agenda, Archive, ArchiveDocument,
          Comment, Like, Sign
        ], :user_id => user.id

      # 모든 당원은 위키를 수정하고 원복할 수 있다
      can [:update], Wiki
      can [:revert], WikiRevision

      # 캠페이너는 캠페인에 속한 글과 댓글을 삭제할 수 있다
      can :destroy, [Discussion, Petition, Poll, Wiki] do |model|
        user == model.campaign.user
      end
      can :destroy, Comment do |comment|
        comment.commentable.try(:campaign) && user == comment.commentable.campaign.user
      end
    end
  end
end
