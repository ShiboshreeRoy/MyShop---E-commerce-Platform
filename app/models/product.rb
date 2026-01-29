class Product < ApplicationRecord
  belongs_to :store
  has_many :product_variants, dependent: :destroy
  has_and_belongs_to_many :categories
  has_one_attached :image
  has_many_attached :gallery_images
  has_one :inventory_item, class_name: 'InventoryItem', dependent: :destroy
  has_many :reviews, dependent: :destroy

  
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[active inactive draft archived] }
  validates :sku, uniqueness: { case_sensitive: false }, allow_blank: true
  validates :condition, inclusion: { in: %w[new used refurbished] }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :dimensions_length, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :dimensions_width, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :dimensions_height, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  
  before_validation :generate_sku, on: :create
  
  def generate_sku
    self.sku = "#{store.id}-#{name.parameterize}" if name.present? && sku.blank?
  end
  
  def in_stock?
    stock_quantity > 0
  end
  
  def on_sale?
    product_variants.any? { |variant| variant.price < price }
  end
  
  def featured_image
    image.attached? ? image : gallery_images.first
  end
end
