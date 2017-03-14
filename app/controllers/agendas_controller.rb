class AgendasController < ApplicationController
  load_and_authorize_resource

  def index
    @agendas = Agenda.order('id DESC')
  end

  def show
  end

  def new_email
    @member = AssemblyMember.find(params[:assembly_member_id])
    render_404 and return if @member.blank?
  end

  def send_email
    @member = AssemblyMember.find(params[:assembly_member_id])
    render_404 and return if @member.blank? or @member.assemEmail.blank?

    AgendaMailer.push(params[:sender], @member.empNm, @member.assemEmail, @agenda.id, params[:title], params[:body]).deliver_later

    flash[:success] = '메일을 발송했습니다'
    redirect_to @agenda
  end
end
