class MigrateAgendaThemes < ActiveRecord::Migration[5.0]
  def change
    AgendaTheme.create(title: '미래에서 온 투표', body: '초록우산 어린이재단의 대한민국 아동이 제안하는 19대 대선 아동공약입니다.', slug: 'votefuture')
    AgendaTheme.create(title: '2017대선오디션', body: '2017대선주권자행동과 함께 대선후보 정책을 검증합니다.', slug: '2017-president')

    %w(votefuture 2017-president).each do |tag|
      Agenda.tagged_with(tag).each { |a| a.agenda_themes << AgendaTheme.find_by(slug: tag); a.tag_list.remove(tag); a.save }
    end

    %w(votefuture 2017-president).each do |tag|
      Issue.tagged_with(tag).each { |a| a.agenda_theme = AgendaTheme.find_by(slug: tag); a.tag_list.remove(tag); a.save }
    end

  end
end
