namespace :sympathy do
  desc "추모하기 데이터를 캠페인 데이터로 옮깁니다."
  task migrate: :environment do
    puts "추모하기 데이터 옮기기 작업"
    Sympathy.all.each do |x|
      c = Campaign.create(
        title: x.title, body: x.body, user: x.user,
        created_at: x.created_at, updated_at: x.updated_at,
        social_image: x.social_image, previous_event_id: x.id
      )
      x.comments.each do |co|
        co.commentable = c
        co.save
      end
    end
  end

end
