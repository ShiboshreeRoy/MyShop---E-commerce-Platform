class Review < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :order, optional: true
  
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :title, length: { maximum: 100 }, allow_blank: true
  validates :content, length: { maximum: 1000 }, allow_blank: true
  validates :status, inclusion: { in: %w[pending approved rejected] }
  
  scope :approved, -> { where(status: 'approved') }
  scope :by_rating, ->(rating) { where(rating: rating) }
  scope :recent, -> { order(created_at: :desc) }
  
  def approve!
    update!(status: 'approved', approved_at: Time.current)
  end
  
  def reject!
    update!(status: 'rejected')
  end
  
  def approved?
    status == 'approved'
  end
  
  def pending?
    status == 'pending'
  end
  
  def rejected?
    status == 'rejected'
  end
  
  def helpful?
    # Could be expanded to track if other users found the review helpful
    true
  end
end
