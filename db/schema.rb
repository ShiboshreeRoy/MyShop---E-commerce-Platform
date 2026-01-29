# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_29_105840) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "analytics_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "data"
    t.text "description"
    t.json "filters"
    t.string "frequency"
    t.datetime "generated_at"
    t.boolean "is_public", default: false
    t.string "name"
    t.string "report_type"
    t.datetime "scheduled_at"
    t.string "status", default: "processing"
    t.integer "store_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["generated_at"], name: "index_analytics_reports_on_generated_at"
    t.index ["report_type"], name: "index_analytics_reports_on_report_type"
    t.index ["status"], name: "index_analytics_reports_on_status"
    t.index ["store_id"], name: "index_analytics_reports_on_store_id"
    t.index ["user_id"], name: "index_analytics_reports_on_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.datetime "created_at", null: false
    t.json "customizations"
    t.integer "product_variant_id", null: false
    t.integer "quantity"
    t.decimal "total_price", precision: 10, scale: 2
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_variant_id"], name: "index_cart_items_on_cart_id_and_product_variant_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_variant_id"], name: "index_cart_items_on_product_variant_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "extra_data"
    t.integer "item_count", default: 0
    t.string "session_id"
    t.decimal "shipping_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["session_id"], name: "index_carts_on_session_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.text "meta_description"
    t.string "meta_title"
    t.string "name"
    t.integer "parent_id"
    t.integer "position", default: 0
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_categories_on_active"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["position"], name: "index_categories_on_position"
    t.index ["slug"], name: "index_categories_on_slug"
  end

  create_table "categories_products", id: false, force: :cascade do |t|
    t.integer "category_id", null: false
    t.integer "product_id", null: false
    t.index ["category_id", "product_id"], name: "index_categories_products_on_category_id_and_product_id"
    t.index ["product_id", "category_id"], name: "index_categories_products_on_product_id_and_category_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "code"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "discount_type", default: "percentage"
    t.datetime "expires_at"
    t.decimal "minimum_order_value", precision: 10, scale: 2, default: "0.0"
    t.datetime "starts_at"
    t.datetime "updated_at", null: false
    t.integer "usage_limit"
    t.integer "used_count", default: 0
    t.integer "user_id"
    t.decimal "value", precision: 10, scale: 2
    t.index ["active"], name: "index_discounts_on_active"
    t.index ["code"], name: "index_discounts_on_code", unique: true
    t.index ["user_id"], name: "index_discounts_on_user_id"
  end

  create_table "email_campaigns", force: :cascade do |t|
    t.text "body"
    t.integer "bounced_count", default: 0
    t.integer "clicked_count", default: 0
    t.datetime "created_at", null: false
    t.text "html_body"
    t.string "name"
    t.integer "opened_count", default: 0
    t.datetime "scheduled_at"
    t.string "segment"
    t.datetime "sent_at"
    t.string "status", default: "draft"
    t.string "subject"
    t.integer "total_recipients", default: 0
    t.boolean "track_clicks", default: true
    t.boolean "track_opens", default: true
    t.integer "unsubscribed_count", default: 0
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["scheduled_at"], name: "index_email_campaigns_on_scheduled_at"
    t.index ["status"], name: "index_email_campaigns_on_status"
    t.index ["user_id"], name: "index_email_campaigns_on_user_id"
  end

  create_table "inventory_items", force: :cascade do |t|
    t.integer "available_quantity", default: 0
    t.integer "committed_quantity", default: 0
    t.datetime "created_at", null: false
    t.date "last_updated"
    t.string "location"
    t.integer "product_id", null: false
    t.integer "quantity", default: 0
    t.integer "reserved_quantity", default: 0
    t.datetime "updated_at", null: false
    t.index ["available_quantity"], name: "index_inventory_items_on_available_quantity"
    t.index ["product_id"], name: "index_inventory_items_on_product_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "customizations"
    t.string "name"
    t.integer "order_id", null: false
    t.integer "product_variant_id", null: false
    t.integer "quantity"
    t.decimal "total_price", precision: 10, scale: 2
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_variant_id"], name: "index_order_items_on_product_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.json "billing_address"
    t.datetime "created_at", null: false
    t.integer "discount_id"
    t.decimal "discount_total", precision: 10, scale: 2, default: "0.0"
    t.string "fulfillment_status", default: "pending"
    t.string "order_number"
    t.string "payment_status", default: "pending"
    t.json "shipping_address"
    t.decimal "shipping_total", precision: 10, scale: 2, default: "0.0"
    t.text "special_instructions"
    t.string "status", default: "pending"
    t.integer "store_id", null: false
    t.decimal "subtotal", precision: 10, scale: 2
    t.decimal "tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["discount_id"], name: "index_orders_on_discount_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["payment_status"], name: "index_orders_on_payment_status"
    t.index ["status"], name: "index_orders_on_status"
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.json "gateway_metadata"
    t.string "gateway_response_code"
    t.text "gateway_response_message"
    t.integer "order_id", null: false
    t.string "payment_method"
    t.datetime "processed_at"
    t.string "status", default: "pending"
    t.string "transaction_id"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["status"], name: "index_payments_on_status"
    t.index ["transaction_id"], name: "index_payments_on_transaction_id"
  end

  create_table "product_variants", force: :cascade do |t|
    t.boolean "available", default: true
    t.datetime "created_at", null: false
    t.string "name"
    t.text "option_values"
    t.decimal "price", precision: 10, scale: 2
    t.integer "product_id", null: false
    t.string "sku"
    t.integer "stock_quantity", default: 0
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_variants_on_product_id"
    t.index ["sku"], name: "index_product_variants_on_sku", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.boolean "allow_out_of_stock_purchases", default: false
    t.boolean "available", default: true
    t.string "barcode"
    t.text "care_instructions"
    t.decimal "compare_at_price", precision: 10, scale: 2
    t.string "condition", default: "new"
    t.decimal "cost_per_item", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.text "description"
    t.string "dimensions"
    t.decimal "dimensions_height", precision: 10, scale: 2
    t.decimal "dimensions_length", precision: 10, scale: 2
    t.decimal "dimensions_width", precision: 10, scale: 2
    t.boolean "featured", default: false
    t.integer "low_stock_threshold", default: 5
    t.string "material"
    t.text "meta_description"
    t.string "meta_title"
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.text "short_description"
    t.string "sku"
    t.string "status", default: "active"
    t.integer "stock_quantity", default: 0
    t.integer "store_id", null: false
    t.string "tags"
    t.boolean "taxable", default: true
    t.datetime "updated_at", null: false
    t.string "weight"
    t.index ["available"], name: "index_products_on_available"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["status"], name: "index_products_on_status"
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "approved_at"
    t.text "content"
    t.datetime "created_at", null: false
    t.integer "order_id"
    t.integer "product_id", null: false
    t.integer "rating", limit: 1
    t.string "status", default: "pending"
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.boolean "verified_purchase", default: false
    t.index ["order_id"], name: "index_reviews_on_order_id"
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["rating"], name: "index_reviews_on_rating"
    t.index ["status"], name: "index_reviews_on_status"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "shipping_rates", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "carrier"
    t.string "country", default: "US"
    t.datetime "created_at", null: false
    t.string "currency", default: "USD"
    t.integer "delivery_days"
    t.decimal "max_price", precision: 10, scale: 2
    t.decimal "max_weight", precision: 10, scale: 2
    t.decimal "min_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "min_weight", precision: 10, scale: 2, default: "0.0"
    t.decimal "rate", precision: 10, scale: 2
    t.string "service_type"
    t.string "state"
    t.datetime "updated_at", null: false
    t.string "zip_code"
    t.index ["active"], name: "index_shipping_rates_on_active"
    t.index ["carrier"], name: "index_shipping_rates_on_carrier"
    t.index ["service_type"], name: "index_shipping_rates_on_service_type"
  end

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "custom_css"
    t.text "custom_js"
    t.text "description"
    t.string "favicon"
    t.string "logo"
    t.string "name"
    t.string "primary_color", default: "#4f46e5"
    t.boolean "published", default: false
    t.string "secondary_color", default: "#f9fafb"
    t.string "slug"
    t.string "status", default: "active"
    t.string "theme", default: "default"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "visibility", default: "public"
    t.index ["slug"], name: "index_stores_on_slug", unique: true
    t.index ["status"], name: "index_stores_on_status"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "customer"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "analytics_reports", "stores"
  add_foreign_key "analytics_reports", "users"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "product_variants"
  add_foreign_key "carts", "users"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "discounts", "users"
  add_foreign_key "email_campaigns", "users"
  add_foreign_key "inventory_items", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_variants"
  add_foreign_key "orders", "discounts"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_variants", "products"
  add_foreign_key "products", "stores"
  add_foreign_key "reviews", "orders"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "stores", "users"
end
