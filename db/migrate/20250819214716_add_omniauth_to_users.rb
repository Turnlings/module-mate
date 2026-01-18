class AddOmniauthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string unless column_exists?(:users, :provider)

    return if column_exists?(:users, :uid)

    add_column :users, :uid, :string
  end
end
