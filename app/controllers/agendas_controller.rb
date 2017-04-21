class AgendasController < ApplicationController
  load_and_authorize_resource
  before_action :reset_meta_tags, only: :theme

  def index
    @agendas = Agenda.order('id DESC')
  end

  def show
    if params[:theme_slug].present?
      redirect_to theme_agendas_path(theme_slug: params[:theme_slug], anchor: view_context.dom_id(@agenda))
      return
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
    @agenda_theme = AgendaTheme.find_by(slug: params[:theme_slug])
    @agendas = @agenda_theme.agendas
  end

  def theme_widget
    theme
    render layout: 'strip'
  end

  def theme_single_widget
    @agenda_theme = AgendaTheme.find_by(slug: params[:theme_slug])
    render layout: 'strip'
  end

  private

  def reset_meta_tags
    prepare_meta_tags({
      title: '2017대선오디션 새로운 대한민국을 이끌 적임자는 누구? 시민이 직접 검증하고 선택해요!',
      description: '촛불대선, 새로운 대한민국을 만들기 위해 바꾸어야 할 과제들이 많지요. 대선 후보자들이 과거와 현재 어떤 입장을 갖고 있는지 제대로 뜯어보고 살펴보고, 찬/반을 선택해주세요. (* 이슈와 후보자별 검증 내용은 계속 업데이트 됩니다)',
      url: request.original_url,
      image: view_context.image_url('events/2017-president.jpg')
    })
  end
end
