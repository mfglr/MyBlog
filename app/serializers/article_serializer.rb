class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published
  has_many :comments
  has_many :tags

  def comments
    object.comments.where(status: :approved)
  end

  def tags
    object.tags.map{ |tag| tag.name }
  end
end
