class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :search, :social_card, :recent_documents], :all
    can [:events], Project
    can :create, [Sign, Comment, Like]
    can :cancel, Like
    can :create_by_slack, Article
    can :download, Timeline

    if user
      can :create, [
          FollowingIssue,
          Project, Discussion, Petition, Poll, Feedback, Survey, Wiki,
          Memorial, Agenda, Timeline, TimelineDocument, Event,
          Election, Candidate, Article, Person, Race, Player,
          Thumb
        ]
      can [:update, :destroy], [
          FollowingIssue,
          Project, Discussion, Petition, Poll, Survey, Wiki,
          Memorial, Agenda, Timeline, TimelineDocument, Event,
          Comment, Sign, Election, Candidate, Article, Person,
          Race, Player
        ], :user_id => user.id

      can :data, [Petition], user_id: user.id

      # 모든 당원은 위키를 수정하고 원복할 수 있다
      can [:update], Wiki
      can [:revert], WikiRevision

      # 프로젝트 개설자는 프로젝트에 속한 글과 댓글을 삭제할 수 있다
      can :destroy, [Discussion, Petition, Poll, Survey, Wiki, Event] do |model|
        model.project && user == model.project.user
      end
      can :destroy, Comment do |comment|
        comment.commentable.try(:project) && user == comment.commentable.project.user
      end

      if user.has_role? :admin
        can :manage, :all
      end
    end
  end
end
