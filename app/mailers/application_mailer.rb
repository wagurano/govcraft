class ApplicationMailer < ActionMailer::Base
  helper :application # gives access to all helpers defined within `application_helper`.
  default from: "contact@govcraft.org"
  layout 'mailer'

  def summary(user, new_projects, new_petitions, new_polls, new_articles)
    @new_projects = new_projects
    @new_petitions = new_petitions
    @new_polls = new_polls
    @new_articles = new_articles

    return if [@new_projects, @new_petitions, @new_polls, @new_articles].select { |news| news.any? }.blank?

    @user = user
    subject = ['[가브크래프트] 이번 주엔 어떤 소식이 올라왔을까요?',
      '[가브크래프트] 이 주엔 어떤 일들이 있었는지 확인하세요.',
      '[가브크래프트] 어떤 이야기들이 나오고 있을까요?',
      '[가브크래프트] 잘지내시나요? 가브크래프트 이야기들을 전합니다.',
      '[가브크래프트] 이번 주 이야기들이 도착했습니다!'].sample

    mail(template_name: 'summary', to: @user.email, subject: "#{I18n.l Date.today} #{subject}")
  end
end
