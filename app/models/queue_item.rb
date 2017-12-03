class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video # == queue_item.video_title
  
  validates_numericality_of :position, {only_integer: true}
  
  def rating
    review.rating if review
  end
  
  def rating=(new_rating)
    if review
      # update_column can bypass validations while update_attributues can't
      review.update_column(:rating, new_rating)
    else
      review = Review.create(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end
  
  def category_name
    category.name        # video.category.name without delegate method
  end
  
  def review
    # @review ||= Review.where(user_id: user.id, video_id: video.id).first
    @review ||= user.reviews.find_by(video: video)
  end
  
end