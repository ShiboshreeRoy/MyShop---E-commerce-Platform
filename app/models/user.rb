class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :stores, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :analytics_reports, dependent: :destroy
  
  validates :role, inclusion: { in: %w[admin merchant customer] }
  
  def admin?
    role == 'admin'
  end
  
  def merchant?
    role == 'merchant'
  end
  
  def customer?
    role == 'customer'
  end
end
