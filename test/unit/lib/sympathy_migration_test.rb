require 'test_helper'
require 'faker'

class SympathyMigrationTest < ActiveSupport::TestCase
  def setup
    @user = users(:james)
    Sympathy.delete_all
    Campaign.delete_all
    GovCraft::Application.load_tasks
  end

  test 'find the campaign by the sympathy id' do
    puts "case 1"
    x = Sympathy.create(user: @user, title: Faker::Community.characters, body: Faker::Community.quotes)
    pp x
    sleep 1
    Rake::Task['sympathy:migrate'].invoke
    c = Campaign.find_by_previous_event_id(x.id)
    pp c
    assert c, "campaign is not found"
  end

  test 'do not change timestamp' do
    puts "case 2"
    x = Sympathy.create!(user: @user, title: Faker::Community.characters, body: Faker::Community.quotes)
    pp x
    sleep 1
    puts "sleep"
    Rake::Task['sympathy:migrate'].invoke
    Campaign.all.each { |x| pp x}
    c = Campaign.find_by_previous_event_id(x.id)
    pp c
    assert_equal x.created_at, c.created_at, "do not change created_at timestamp"
    assert_equal x.updated_at, c.updated_at, "do not change updated_at timestamp"
  end

  test 'data from sympathy to campaign' do
    skip
    3.times do
      Sympathy.create(user: @user, title: Faker::Community.characters, body: Faker::Community.quotes)
    end
    Rake::Task['sympathy:migrate'].invoke
    Sympathy.all.each do |x|
      c = Campaign.find_by_previous_event_id(x.id)
    end
  end

  test 'data from sympathy to campaign with comments' do
    skip
    3.times do
      x = Sympathy.create(user: @user, title: Faker::Community.characters, body: Faker::Community.quotes)
      2.times { x.comments.create(user: User.first, body: Faker::Community.quotes, mailing: :disable) }
    end
    Rake::Task['sympathy:migrate'].invoke
  end
end
