class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader
  
  validates :title, presence: true
  validates :description, presence: true
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    # use of %: WHERE CustomerName LIKE '%or%':	Finds any values that have "or" in any position
    where("LOWER(title) LIKE ?", "%#{search_term.downcase}%").order("created_at DESC")
  end
  
  def rating
    avg = reviews.average(:rating)
    avg.round(1) if avg
  end
end