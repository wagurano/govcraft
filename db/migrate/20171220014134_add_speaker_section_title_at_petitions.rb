class AddSpeakerSectionTitleAtPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :petitions, :speaker_section_title, :string
    add_column :petitions, :speaker_section_response_title, :string

    reversible do |dir|
      dir.up do
        p55 = Petition.find_by(id: 55)
        p55.update_columns(
          speaker_section_title: '국회 정치개혁 특위에 촉구하기',
          speaker_section_response_title: '국회 정치개혁 특위 응답')

        p55 = Petition.find_by(id: 56)
        p55.update_columns(
          speaker_section_title: '국회 관련 의원 및 서울시 교육감에게 촉구하기',
          speaker_section_response_title: '국회 관련 의원 및 서울시 교육감 응답')
      end
    end
  end
end
