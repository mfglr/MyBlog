class Article < ApplicationRecord
    validates :title, presence: true, length: { maximum: 140 }
    has_rich_text :content
    scope :published_articles, -> { where(published: true).order(created_at: :desc) }
    belongs_to :user
    has_many :article_likes, dependent: :destroy
    has_many :users, through: :article_likes
    has_many :comments, dependent: :destroy
    has_many :article_tags, dependent: :destroy
    has_many :tags, through: :article_tags
    
    def publish
        self.published = true
        save
    end

    def unpublish
        self.published = false
        save
    end
end
