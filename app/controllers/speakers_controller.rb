class SpeakersController < ApplicationController
  load_and_authorize_resource

  def show
    # 우선 반드시 아젠다에 관련된 스피커만 호출한다고 가정합니다.
    @agenda = Agenda.find(params[:agenda_id])
  end
end
