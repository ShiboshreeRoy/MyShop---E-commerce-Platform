class CreateEmailCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :email_campaigns do |t|
      t.string :name
      t.string :subject
      t.text :body
      t.text :html_body # HTML version of the email
      t.string :status, default: 'draft'
      t.datetime :scheduled_at
      t.datetime :sent_at
      t.integer :total_recipients, default: 0
      t.integer :opened_count, default: 0
      t.integer :clicked_count, default: 0
      t.integer :bounced_count, default: 0
      t.integer :unsubscribed_count, default: 0
      t.references :user, null: true, foreign_key: true # Creator of the campaign
      t.boolean :track_opens, default: true
      t.boolean :track_clicks, default: true
      t.string :segment # Which users to send to (e.g., 'customers', 'subscribers', 'abandoned_cart')
      
      t.timestamps
    end
    
    add_index :email_campaigns, :status
    add_index :email_campaigns, :scheduled_at
  end
end
