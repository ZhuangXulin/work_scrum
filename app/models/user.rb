class User < ActiveRecord::Base
	before_save :ensure_authentication_token
	

  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  self.per_page = 15

  #token为空时自动生成新的token
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  #this method is called by devise to check for "active" state of the model
  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using 
    #our own "is_active" column
    super and self.is_active?
  end

  #获取部门用户列表
  def self.get_users(department_id,page)
  	if department_id.nil?
      sql = "select u.id,u.email,u.sign_in_count,u.current_sign_in_ip,u.current_sign_in_at,u.last_sign_in_ip,u.last_sign_in_at,u.is_active,d.department_name 
            from users as u
            left join department_users as du
            on u.id=du.user_id
            left join departments as d 
            on d.id = du.department_id "
  		User.paginate_by_sql(sql, :page => page, :per_page => per_page)
  	else
      sql = "select u.id,u.email,u.sign_in_count,u.current_sign_in_ip,u.current_sign_in_at,u.last_sign_in_ip,u.last_sign_in_at,u.is_active,d.department_name 
            from users as u
            left join department_users as du
            on u.id=du.user_id
            left join departments as d 
            on d.id = du.department_id 
            where du.department_id = #{department_id}"
  		User.paginate_by_sql(sql, :page => page, :per_page => per_page)
  	end
  end

  #创建新用户
  def self.create_new_user(email,password)
    User.create(:email => email,:password => password)
  end

  #修改密码
  def self.update_password(user_id,password)
    User.find(user_id).update_attribute(:password,password)
  end

  #修改用户状态，激活或者是锁定
  def self.set_active_status(user_id,active_status)
    User.find(user_id).update_attribute(:is_active,active_status)
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

end
