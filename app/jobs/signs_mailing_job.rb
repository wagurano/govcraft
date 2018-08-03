class SignsMailingJob
  include Sidekiq::Worker
  def perform(petition_id, title, body, preview_email, user_id)
    @petition = Petition.find_by(id: petition_id)
    return if @petition.blank?
    if preview_email.present?
      user = User.find_by(id: user_id)
      return if user.blank?
      sign = Sign.new(user: user, body: "test", signer_name: user.nickname, signer_email: preview_email, petition: @petition)
      SignMailer.by_campaigner(sign, title, body).deliver_now
    else
      @petition.signs.each do |sign|
        SignMailer.by_campaigner(sign, title, body).deliver_later
      end
    end
  end
end
