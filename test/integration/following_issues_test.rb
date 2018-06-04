require 'test_helper'

class FollowingIssuesTest < ActionDispatch::IntegrationTest
  test '토픽을 만듭니다' do
    skip # https://github.com/parti-xyz/govcraft/commit/d97b148ccc4280c5f4b7e3dd8af0105231ac6c94#diff-21497849d8f00507c9c8dcaf6288b136
    sign_in(users(:one))
    post following_issues_path, params: { following_issue: { issue_title: '새 토픽' } }

    assert assigns(:issue).persisted?
    assert users(:one).following?(assigns(:issue))
  end

  test '이미 있는 토픽을 만듭니다' do
    skip # https://github.com/parti-xyz/govcraft/commit/d97b148ccc4280c5f4b7e3dd8af0105231ac6c94#diff-21497849d8f00507c9c8dcaf6288b136
    sign_in(users(:one))
    post following_issues_path, params: { following_issue: { issue_title: issues(:issue1).title } }

    assert assigns(:issue).persisted?
    assert users(:one).following?(assigns(:issue))
  end
end
