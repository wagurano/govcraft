class Ability
  include CanCan::Ability

  def initialize(user, params = {})
    can [:read, :search, :social_card, :recent_documents], :all
    can [:events], Project
    can :create, [Sign, Comment, Like, Note]
    can :cancel, Like
    can :create_by_slack, Article
    can :download, Timeline
    can [:widget, :new_email, :send_email, :theme, :theme_widget, :theme_single_widget], Agenda
    can :vote_widget, Opinion
    can :agenda, Speaker
    can [:new_comment_speaker], :all
    can [:download], ArchiveDocument
    can [:update_statement_speaker], :all

    if user
      can [:new_email, :send_email], Agenda
      can :create, [
          Project, Story, Discussion, Poll, Feedback, Survey, Wiki, Sympathy,
          Memorial, Timeline, TimelineDocument,
          Election, Candidate, Article, Person, Race, Player,
          Thumb
        ]

      # 서명 만들기
      can :create_peition, [Project] do |project|
        project.blank? or project.organizer?(user)
      end
      can :create, [Petition] do |petition|
        project = petition.try(:project) || (Project.find_by(slug: params[:project_id]) if params[:project_id].present?)
        project.blank? or project.organizer?(user)
      end

      # 이벤트 만들기
      can :create_event, [Project] do |project|
        project.blank? or project.organizer?(user)
      end
      can :create, [Event] do |event|
        project = event.try(:project) || (Project.find_by(slug: params[:project_id]) if params[:project_id].present?)
        project.blank? or project.organizer?(user)
      end

      can [:update, :destroy], [
          Project, Story, Discussion, Petition, Poll, Survey, Wiki, Sympathy,
          Memorial, Timeline, TimelineDocument, Event,
          Sign, Election, Candidate, Article, Person,
          Race, Player
        ], :user_id => user.id
      can :update, Project do |project|
        user == project.user or project.organizer?(user)
      end

      can :pin, Discussion do |discussion|
        user == discussion.user or discussion.try(:project).try(:organizer?, user)
      end

      can [:edit_speakers, :add_speaker, :remove_speaker, :edit_message_to_speaker, :update_message_to_speaker], [Petition, Event] do |event|
        user == event.user or event.try(:project).try(:organizer?, user)
      end

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
        model.project && ( user == model.project.user or model.project.organizer?(user) )
      end

      # 프로젝트 개설자 및 운영자는 프로젝트에 속한 글과 댓글을 삭제할 수 있다
      can [:destroy, :update], [Story, Discussion, Petition, Poll, Survey, Wiki, Event] do |model|
        model.project && ( user == model.project.user or model.project.organizer?(user) )
      end
      can :destroy, Comment do |comment|
        comment.commentable.try(:project) && ( user == comment.commentable.project.user or comment.commentable.project.organizer?(user) )
      end

      # 프로젝트 개설자 및 운영자는 프로젝트 운영자를 관리할 수 있다
      can :manage, Organizer do |organizer|
        if organizer.persisted?
          organizer.organizable && organizer.organizable.organizer?(user)
        elsif params[:organizer][:organizable_type].present?
          model = params[:organizer][:organizable_type].safe_constantize
          return false if model.blank?

          organizable = model.find_by id: params[:organizer][:organizable_id]
          organizable.organizer?(user)
        end
      end
      can :update_organizers, [Project, Organization] do |organizable|
        organizable.organizer?(user)
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
