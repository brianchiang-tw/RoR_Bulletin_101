class Post < ApplicationRecord
  belongs_to :user
  belongs_to :group

  validates :content, presence: true

  # in descending order
  scope :recent, -> { order("created_at DESC") }

end
