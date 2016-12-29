class Citizen2017Job
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform
    candel_speech_event = Event.find_by(slug: Event::SLUG_CANDLE_SPEECH, template: 'speech')
    return unless candel_speech_event.present?

    last_scrapped_citizen2017_id = Citizen2017Speech.last.try(:citizen2017_id) || 0

    list_doc = OpenGraph.new('http://citizen2017.net/b/archive01').doc
    first_item_url = list_doc.xpath('//div[@id="bbslist"]/table//a')[0].attributes['href'].value
    last_citizen2017_id = first_item_url.split('/').last.to_i || 0

    while last_citizen2017_id >= last_scrapped_citizen2017_id do
      last_scrapped_citizen2017_id += 1

      puts "scrapping : #{last_scrapped_citizen2017_id}"

      item = OpenGraph.new("http://citizen2017.net/b/archive01/#{last_scrapped_citizen2017_id}")
      iframe = item.doc.xpath("//iframe").first
      next unless iframe.present?

      video_url = iframe.attributes['src'].value

      begin
        video = VideoInfo.new(video_url)

        if video.available?
          video_url = (video.provider == 'YouTube' ? "http://www.youtube.com/watch?v=#{video.video_id}" : video_url)

          ActiveRecord::Base.transaction do
            citizen_speech = Citizen2017Speech.create!(title: item.doc.title.gsub("국민토크::송박영신, 소원 3개를 말해봐 - ", ""), citizen2017_id: last_scrapped_citizen2017_id, video_url: video_url)

            speech = Speech.create!(event_id: candel_speech_event.id, title: citizen_speech.title, video_url: citizen_speech.video_url)
            citizen_speech.update_attributes!(speech_id: speech.id)
          end

          puts "save video : #{video_url}"
        else
          puts "not video : #{video_url}"
        end
      rescue VideoInfo::UrlError
        puts "not video : #{video_url}"
      end
      sleep(1.0/2.0)
    end
  end
end
