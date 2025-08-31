class AddTermsOfServiceAgreedAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :terms_of_service_agreed_at, :datetime
  end
end
