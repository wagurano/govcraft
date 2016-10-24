require 'test_helper'

class FollowingIssuesTest < ActionDispatch::IntegrationTest
  test '토픽을 만듭니다' do
    sign_in(users(:one))
    post following_issues_path, params: { following_issue: { issue_title: '새 토픽' } }

    assert assigns(:issue).persisted?
    assert users(:one).following?(assigns(:issue))
  end

  test '이미 있는 토픽을 만듭니다' do
    sign_in(users(:one))
    post following_issues_path, params: { following_issue: { issue_title: issues(:issue1).title } }

    assert assigns(:issue).persisted?
    assert users(:one).following?(assigns(:issue))
  end
end
