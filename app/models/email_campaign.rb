class EmailCampaign < ApplicationRecord
  belongs_to :user, optional: true
  
  validates :name, presence: true, length: { maximum: 100 }
  validates :subject, presence: true, length: { maximum: 200 }
  validates :body, presence: true
  validates :status, inclusion: { in: %w[draft scheduled sending sent paused cancelled] }
  validates :segment, inclusion: { in: %w[all customers subscribers abandoned_cart] }, allow_nil: true
  
  scope :draft, -> { where(status: 'draft') }
  scope :scheduled, -> { where(status: 'scheduled') }
  scope :sent, -> { where(status: 'sent') }
  scope :active, -> { where(status: %w[scheduled sending]) }
  scope :by_segment, ->(segment) { where(segment: segment) }
  
  def ready_to_send?
    status == 'scheduled' && scheduled_at.present? && scheduled_at <= Time.current
  end
  
  def send_now!
    update!(status: 'sending')
    # In a real implementation, this would trigger a background job
    # to actually send the emails
    process_campaign
    update!(status: 'sent', sent_at: Time.current)
  end
  
  def deliverability_rate
    return 0 if total_recipients.zero?
    ((total_recipients - bounced_count) / total_recipients.to_f * 100).round(2)
  end
  
  def open_rate
    return 0 if total_recipients.zero?
    (opened_count / total_recipients.to_f * 100).round(2)
  end
  
  def click_rate
    return 0 if clicked_count.zero?
    (clicked_count / opened_count.to_f * 100).round(2)
  end
  
  private
  
  def process_campaign
    # In a real implementation, this would:
    # 1. Find recipients based on segment
    # 2. Send emails via background job
    # 3. Track opens/clicks
    # For now, we'll just simulate the process
    
    # Find recipients based on segment
    recipients = find_recipients
    self.total_recipients = recipients.count
    save!
    
    # In a real app, we'd send emails via a background job
    # MailchimpWorker.perform_async(id)
  end
  
  def find_recipients
    case segment
    when 'customers'
      User.joins(:orders).distinct
    when 'subscribers'
      User.where(newsletter_subscriber: true) # Assuming we have this field
    when 'abandoned_cart'
      User.joins(:carts).where(carts: { updated_at: ..2.hours.ago })
    else
      User.all
    end
  end
end
