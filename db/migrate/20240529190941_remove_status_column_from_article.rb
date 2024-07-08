class RemoveStatusColumnFromArticle < ActiveRecord::Migration[7.1]
  def change
    remove_column :articles, :status, :integer
  end
end
