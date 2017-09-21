class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :search, :social_card, :recent_documents], :all
    can [:events], Project
    can :create, [Sign, Comment, Like, Note]
    can :cancel, Like
    can :create_by_slack, Article
    can :download, Timeline
    can [:widget, :new_email, :send_email, :theme, :theme_widget, :theme_single_widget], Agenda
    can :vote_widget, Opinion
    can :agenda, Speaker
    can [:new_comment_speaker], Petition
    can [:download], ArchiveDocument

    if user
      can [:new_email, :send_email], Agenda
      can :create, [
          Project, Story, Discussion, Petition, Poll, Feedback, Survey, Wiki, Sympathy,
          Memorial, Timeline, TimelineDocument, Event,
          Election, Candidate, Article, Person, Race, Player,
          Thumb
        ]
      can [:update, :destroy], [
          Project, Story, Discussion, Petition, Poll, Survey, Wiki, Sympathy,
          Memorial, Timeline, TimelineDocument, Event,
          Sign, Election, Candidate, Article, Person,
          Race, Player
        ], :user_id => user.id
      can :update, Project do |project|
        user == project.user or project.project_admin?(user)
      end

      can [:edit_speakers, :add_speaker, :remove_speaker], Petition, :user_id => user.id

      can :destroy, Comment do |comment|
        comment.toxic == false && user == comment.user
      end

      can :data, [Petition], user_id: user.id
      can :data, [Event], user_id: user.id

      # 모든 당원은 위키를 수정하고 원복할 수 있다
      can [:update], Wiki
      can [:revert], WikiRevision

      # 프로젝트 개설자 및 운영자는 프로젝트에 속한 이벤트를 수정할 수 있다
      can :update, [Event] do |model|
        model.project && ( user == model.project.user or model.project.project_admin?(user) )
      end

      # 프로젝트 개설자 및 운영자는 프로젝트에 속한 글과 댓글을 삭제할 수 있다
      can [:destroy, :update], [Story, Discussion, Petition, Poll, Survey, Wiki, Event] do |model|
        model.project && ( user == model.project.user or model.project.project_admin?(user) )
      end
      can :destroy, Comment do |comment|
        comment.commentable.try(:project) && ( user == comment.commentable.project.user or comment.commentable.project.project_admin?(user) )
      end

      # 프로젝트 개설자 및 운영자는 프로젝트 운영자를 관리할 수 있다
      can :manage, ProjectAdmin do |pj|
        pj.project && pj.project.project_admin?(user)
      end

      begin
        if user.has_role? :admin
          can :manage, :all
        end
      rescue NameError => e
        Rails.logger.error user.inspect
        raise e
      end
    end
  end
end
