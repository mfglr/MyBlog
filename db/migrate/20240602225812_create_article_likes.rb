class CreateArticleLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :article_likes,primary_key: [:article_id, :user_id] do |t|
      t.belongs_to :article, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
