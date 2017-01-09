class SummaryMailingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform
    new_projects = Project.past_week

    new_petitions = Petition.past_week
    new_polls = Poll.past_week
    new_events = Event.past_week
    new_articles = Article.past_week

    return if [new_projects,
      new_petitions, new_polls, new_events, new_articles].select { |news| news.any? }.blank?

    User.with_role(:admin).where(enable_mailing: true).each do |user|
      ApplicationMailer.summary(user, new_projects, new_petitions, new_polls, new_events, new_articles).deliver_now
    end
  end
end
