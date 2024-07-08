class AddStatusColumnToComment < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :status, :integer
  end
end
