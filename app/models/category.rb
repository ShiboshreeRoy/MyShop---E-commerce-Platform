class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_and_belongs_to_many :products
  has_one_attached :image
  
  validates :name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :slug, uniqueness: true, allow_blank: true
  
  before_validation :generate_slug, on: :create
  
  def generate_slug
    self.slug = name.downcase.gsub(/[^a-z0-9]+/, '-') if name.present?
  end
  
  def full_name
    parent ? "#{parent.name} > #{name}" : name
  end
  
  def has_children?
    children.exists?
  end
end
