class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :body
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :article, index: true, foreign_key: true
      
      t.timestamps
    end
  end
end
