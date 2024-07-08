class AddNickNameToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :nick_name, :string, null: false
  end
end
