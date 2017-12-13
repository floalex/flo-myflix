class Review < ActiveRecord::Base
  belongs_to :video, touch: true  # whenever the review is updated, it also updates video, also triggers callbacks
  belongs_to :user
  
  validates :content, presence: true
  validates :rating, presence: true, inclusion: { in: 1..5 }
end