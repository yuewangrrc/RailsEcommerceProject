module OrdersHelper
  def order_status_class(status)
    case status.to_s
    when 'pending'
      'warning'
    when 'processing'
      'info'
    when 'shipped'
      'primary'
    when 'delivered'
      'success'
    when 'cancelled'
      'danger'
    else
      'secondary'
    end
  end

  def order_status_icon(status)
    case status.to_s
    when 'pending'
      'fas fa-clock'
    when 'processing'
      'fas fa-cog fa-spin'
    when 'shipped'
      'fas fa-truck'
    when 'delivered'
      'fas fa-check-circle'
    when 'cancelled'
      'fas fa-times-circle'
    else
      'fas fa-question-circle'
    end
  end
end
