class AddPasswordToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :admin, :boolean, default: false
  end
end
