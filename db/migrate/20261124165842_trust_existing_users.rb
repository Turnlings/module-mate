class TrustExistingUsers < ActiveRecord::Migration[8.1]
  def change
    # rubocop:disable-next Rails/SkipsModelValidations
    User.where(confirmed_at: nil).update_all(
      confirmed_at: Time.current
    )
  end
end
