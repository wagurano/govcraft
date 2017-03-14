class AgendaMailer < ApplicationMailer
  def push(sender, recipient_name, recipient_email, agenda_id, title, body)
    @agenda = Agenda.find_by id: agenda_id
    return if [@agenda, sender, recipient_name, recipient_email, title, body].any? &:blank?
    @title = title
    @body = body
    @sender = sender
    @recipient_name = recipient_name
    mail(to: recipient_email,
      subject: title)
  end
end
