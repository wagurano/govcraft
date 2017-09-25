class PartiHightlightPostsJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform
    highlight_posts = RestClient.get "#{ENV["PARTI_API_BASE"]}v1/groups/kdemo/highlight_posts?limit=10"
    Rails.cache.write "urimanna_parti_highlight_posts", JSON.parse(highlight_posts.body)
  end
end
