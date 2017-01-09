class SummaryMailingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform
    new_projects = Project.past_month

    new_petitions = Petition.past_month
    new_polls = Poll.past_month
    new_events = Event.past_month

    return if [new_projects,
      new_petitions, new_polls, new_events].select { |news| news.any? }.blank?

    User.with_role(:admin).where(enable_mailing: true).each do |user|
      ApplicationMailer.summary(user, new_projects, new_petitions, new_polls, new_events).deliver_now
    end
  end
end
