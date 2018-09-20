namespace :sympathy do
  desc "추모하기 데이터를 캠페인 데이터로 옮깁니다."
  task migrate: :environment do
    puts "추모하기 데이터 옮기기 작업"
    ActiveRecord::Base.transaction do
      Sympathy.all.each do |x|
        c = Campaign.find_by_previous_event_id(x.id)
        unless c and c.valid?
          c = Campaign.create!(
            title: x.title, body: x.body, user: x.user,
            created_at: x.created_at, updated_at: x.updated_at,
            cover_image: nil, previous_event_id: x.id)
          c.remote_social_image_url = x.social_image_url if x.read_attribute(:social_image).present?
          x.comments.each do |co|
            co.commentable = c
            co.save
          end
        end
      end
    end
  end

end
