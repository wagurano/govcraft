class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def summary(user, new_campaigns, new_petitions, new_polls, new_events)
    @new_campaigns = new_campaigns
    @new_petitions = new_campaigns
    @new_polls = new_polls
    @new_events = new_events

    return if [@new_campaigns, @new_petitions, @new_polls, @new_events].select { |news| news.any? }.blank?

    @user = user
    subject = ['이번 주엔 어떤 소식이 올라왔을까요?',
      '이 주엔 어떤 일들이 있었는지 확인하세요.',
      '어떤 이야기들이 나오고 있을까요?',
      '잘지내시나요? 우주당 이야기들을 전합니다.',
      '우주당의 새 소식들을 확인해보세요.',
      '이번 주 이야기들이 도착했습니다!'].sample

    mail(template_name: 'summary', to: @user.email, subject: "#{I18n.l Date.today} #{subject}")
  end
end
