class Store < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :analytics_reports, dependent: :destroy
  has_one_attached :logo
  has_one_attached :cover_image
  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :status, inclusion: { in: %w[active inactive suspended] }
  validates :theme, inclusion: { in: %w[default modern minimal dark vintage] }
  validates :primary_color, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, message: 'must be a valid hex color' }, allow_blank: true
  validates :secondary_color, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, message: 'must be a valid hex color' }, allow_blank: true
  validates :visibility, inclusion: { in: %w[public private] }
  
  before_validation :generate_slug, on: :create
  
  def generate_slug
    self.slug = name.downcase.gsub(/[^a-z0-9]+/, '-') if name.present?
  end
  
  def active?
    status == 'active'
  end
  
  def public?
    visibility == 'public'
  end
end
