class TrustExistingAccounts < ActiveRecord::Migration[8.1]
  def change
    User.where(confirmed_at: nil).update_all(
      confirmed_at: Time.current
    )
  end
end
