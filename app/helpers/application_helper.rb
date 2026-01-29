module ApplicationHelper
  def admin?
    user_signed_in? && current_user.admin?
  end
  
  def merchant?
    user_signed_in? && current_user.merchant?
  end
  
  def customer?
    user_signed_in? && current_user.customer?
  end
  
  def current_user_role
    return 'guest' unless user_signed_in?
    current_user.role
  end
end
