require 'test_helper'
require 'faker'

class SympathyMigrationTest < ActiveSupport::TestCase
  def setup
    @user = users(:james)
    GovCraft::Application.load_tasks
  end

  test 'data from sympathy to campaign' do
    3.times do
      Sympathy.create(user: @user, title: Faker::Community.characters, body: Faker::Community.quotes)
    end
    Rake::Task['sympathy:migrate'].invoke
  end

  test 'data from sympathy to campaign with comments' do
    3.times do
      x = Sympathy.create(user: @user, title: Faker::Community.characters, body: Faker::Community.quotes)
      2.times { x.comments.create(user: User.first, body: Faker::Community.quotes, mailing: :disable) }
    end
    Rake::Task['sympathy:migrate'].invoke
  end
end
