class Log < ActiveRecord::Base

  #记录用户操作日志
  def self.log_user_action(user_id,user_ip,type_of_action)
    log = Log.new()
    log.user_id = user_id
    log.user_ip = user_ip
    log.type_of_action = type_of_action
    log.save
  end
end
