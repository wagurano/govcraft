class AgendasController < ApplicationController
  load_and_authorize_resource except: [:themes]

  def index
    @agendas = Agenda.order('id DESC')
  end

  def show
    if params[:theme_tag].present?
      redirect_to theme_agendas_path(theme_tag: params[:theme_tag], anchor: view_context.dom_id(@agenda))
    end
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

    if %i(sender title body).any? { |k| params[k].blank? }
      flash[:error] = '값을 모두 채워주세요'
      render 'new_email' and return
    end
    AgendaMailer.push(params[:sender], @speaker.name, @speaker.email, @agenda.id, params[:title], params[:body]).deliver_later
    @speaker.sent_requests.create(user: current_user, agenda: @agenda)

    flash[:success] = '메일을 발송했습니다'
    redirect_to speaker_path(@speaker, agenda_id: @agenda.id)
  end

  def theme
    @agendas = Agenda.tagged_with(params[:theme_tag])
  end
end
