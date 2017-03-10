class Admin::UsersController < Admin::BaseController
  def download_emails
    emails_before = User.select { |u| u.email.present? }.map { |u| { nickname: u.nickname,
      email: u.email } }
    @emails = emails_before.uniq! {|e| e[:email] }

    respond_to do |format|
      format.xlsx
    end
  end
end

