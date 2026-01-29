class CreateAnalyticsReports < ActiveRecord::Migration[8.1]
  def change
    create_table :analytics_reports do |t|
      t.string :name
      t.string :report_type # sales, traffic, customer, inventory, etc.
      t.json :filters # Store filter criteria for the report
      t.json :data # Store the actual report data
      t.string :status, default: 'processing'
      t.datetime :generated_at
      t.references :user, null: true, foreign_key: true # User who generated the report
      t.references :store, null: true, foreign_key: true # Store the report belongs to
      t.datetime :scheduled_at # For scheduled reports
      t.string :frequency # daily, weekly, monthly for scheduled reports
      t.boolean :is_public, default: false # Whether report is public
      t.text :description
      
      t.timestamps
    end
    
    add_index :analytics_reports, :report_type
    add_index :analytics_reports, :status
    add_index :analytics_reports, :generated_at
  end
end
