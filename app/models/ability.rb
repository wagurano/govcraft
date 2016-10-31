class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    can :create, Sign

    if user
      can :create, [
          FollowingIssue, Campaign, Discussion, Petition, Poll,
          Memorial, Agenda, Archive, ArchiveDocument,
          Comment, Like
        ]
      can [:update, :destroy], [
          FollowingIssue, Campaign, Discussion, Petition, Poll,
          Memorial, Agenda, Archive, ArchiveDocument,
          Comment, Like, Sign
        ], :user_id => user.id

      # 캠페이너는 캠페인에 속한 글과 댓글을 삭제할 수 있다
      can :destroy, [Discussion, Petition, Poll] do |model|
        user == model.campaign.user
      end
      can :destroy, Comment do |comment|
        comment.commentable.try(:campaign) && user == comment.commentable.campaign.user
      end
    end
  end
end
