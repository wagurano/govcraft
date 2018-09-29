require 'test_helper'

class CampaignSympathyTest < ActionDispatch::IntegrationTest

  test 'add sympathy button' do
    sign_in users(:james)
    visit new_campaign_path
    assert page.has_content?('추모하기')
  end
end
