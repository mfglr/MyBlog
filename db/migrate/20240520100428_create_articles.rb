class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :content
      t.integer :status, null: false

      t.timestamps
    end
  end
end
