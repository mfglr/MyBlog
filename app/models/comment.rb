class Comment < ApplicationRecord
    enum :status, [ :pending, :approved, :rejected ]
    belongs_to :article
    belongs_to :user
    validates :body, presence: true
end
