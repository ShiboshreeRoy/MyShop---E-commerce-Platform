# Create admin user
admin = User.find_or_create_by(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'admin'
end

puts "Created admin user: #{admin.email}"

# Create merchant user
merchant = User.find_or_create_by(email: 'merchant@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'merchant'
end

puts "Created merchant user: #{merchant.email}"

# Create customer user
customer = User.find_or_create_by(email: 'customer@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'customer'
end

puts "Created customer user: #{customer.email}"

# Create a store for the merchant
store = Store.find_or_create_by(name: 'Demo Store') do |s|
  s.description = 'A beautiful demo store showcasing our products'
  s.user = merchant
  s.theme = 'modern'
  s.status = 'active'
  s.published = true
  s.primary_color = '#4f46e5'
  s.secondary_color = '#f9fafb'
end

puts "Created store: #{store.name}"

# Create some categories
categories = []
categories << Category.find_or_create_by!(name: 'Electronics', description: 'Electronic devices and accessories')
categories << Category.find_or_create_by!(name: 'Clothing', description: 'Fashion and apparel')
categories << Category.find_or_create_by!(name: 'Home & Garden', description: 'Home decor and gardening supplies')
categories << Category.find_or_create_by!(name: 'Books', description: 'Books and literature')

puts "Created #{categories.count} categories"

# Create some products
products = []
products << Product.find_or_create_by!(name: 'Smartphone', price: 699.99, description: 'Latest smartphone with advanced features', short_description: 'High-tech smartphone', store: store, status: 'active', condition: 'new') do |p|
  p.stock_quantity = 50
  p.available = true
end

products << Product.find_or_create_by!(name: 'Laptop', price: 1299.99, description: 'Powerful laptop for work and gaming', short_description: 'High-performance laptop', store: store, status: 'active', condition: 'new') do |p|
  p.stock_quantity = 30
  p.available = true
end

products << Product.find_or_create_by!(name: 'Coffee Maker', price: 89.99, description: 'Automatic coffee maker with timer', short_description: 'Programmable coffee maker', store: store, status: 'active', condition: 'new') do |p|
  p.stock_quantity = 25
  p.available = true
end

products << Product.find_or_create_by!(name: 'Bestselling Novel', price: 14.99, description: 'Award-winning novel everyone is talking about', short_description: 'Popular fiction book', store: store, status: 'active', condition: 'new') do |p|
  p.stock_quantity = 100
  p.available = true
end

puts "Created #{products.count} products"

# Create product variants
smartphone_variant = ProductVariant.find_or_create_by!(name: '128GB Black', product: products[0], price: 699.99) do |v|
  v.stock_quantity = 20
  v.sku = 'PHONE-BLK-128GB'
  v.available = true
end

laptop_variant = ProductVariant.find_or_create_by!(name: '16GB RAM', product: products[1], price: 1299.99) do |v|
  v.stock_quantity = 15
  v.sku = 'LAPTOP-16GB'
  v.available = true
end

puts "Created #{ProductVariant.count} product variants"

# Assign categories to products
products[0].categories << categories[0]  # Smartphone -> Electronics
products[1].categories << categories[0]  # Laptop -> Electronics
products[2].categories << categories[2]  # Coffee Maker -> Home & Garden
products[3].categories << categories[3]  # Book -> Books

puts "Assigned categories to products"

# Create inventory items
products.each do |product|
  InventoryItem.find_or_create_by!(product: product) do |ii|
    ii.quantity = product.stock_quantity
    ii.available_quantity = product.stock_quantity
  end
end

puts "Created inventory items"

# Create some shipping rates
ShippingRate.find_or_create_by!(carrier: 'UPS', service_type: 'Ground', rate: 7.99, min_weight: 0, max_weight: 5, country: 'US') do |sr|
  sr.delivery_days = 5
end

ShippingRate.find_or_create_by!(carrier: 'FedEx', service_type: 'Express', rate: 12.99, min_weight: 0, max_weight: 5, country: 'US') do |sr|
  sr.delivery_days = 2
end

puts "Created shipping rates"

# Create discount codes
Discount.find_or_create_by!(code: 'WELCOME10', discount_type: 'percentage', value: 10, usage_limit: 100, active: true) do |d|
  d.description = 'Welcome discount for new customers'
end

Discount.find_or_create_by!(code: 'FREESHIP', discount_type: 'free_shipping', value: 0, usage_limit: 50, active: true) do |d|
  d.description = 'Free shipping promotion'
end

puts "Created discount codes"

puts "Database seeded successfully!"
