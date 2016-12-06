module ApplicationHelper

  def display_notice_and_alert
    msg = ''
    msg << (content_tag :div, notice, :class => "notice", :style => "color:green") if notice
    msg << (content_tag :div, alert, :class => "alert", :style => "color:red") if alert
    sanitize msg
  end

end
