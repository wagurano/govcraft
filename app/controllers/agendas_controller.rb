class AgendasController < ApplicationController
  load_and_authorize_resource

  def index
    @agendas = Agenda.order('id DESC')
  end

  def show
  end

  def widget
    render layout: 'strip'
  end

  def new_email
    @speaker = Speaker.find(params[:speaker_id])
    render_404 and return if @speaker.blank?
  end

  def send_email
    @speaker = Speaker.find(params[:speaker_id])
    render_404 and return if @speaker.blank? or @speaker.email.blank?

    AgendaMailer.push(params[:sender], @speaker.name, @speaker.email, @agenda.id, params[:title], params[:body]).deliver_later
    @speaker.sent_requests.create(user: current_user)

    flash[:success] = '메일을 발송했습니다'
    redirect_to speaker_path(@speaker, agenda_id: @agenda.id)
  end
end
