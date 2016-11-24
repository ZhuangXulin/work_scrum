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

  #获取全部用户列表
  def self.get_all_users
    User.all
  end

  #获取全部的用户列表（不包括admin和manager）
  def self.get_all_users_without_admin_and_manager
    sql = "select users.* from users,users_roles where users.id = users_roles.user_id and users_roles.role_id not in (1,2)"
    User.find_by_sql(sql)
  end

  #获取某一个部门的用户列表
  def self.get_department_users(department_id)
    sql = "select 'users'.* from 'users','department_users' where 'users'.'id' = 'department_users'.'user_id' and 'department_users'.'department_id' = '#{department_id}'"
    User.find_by_sql(sql)
  end

  #获取某一个部门的用户列表（不包括部门的管理员）
  def self.get_department_users_without_manager(department_id)
    sql = "select 'users'.* from 'users','department_users','users_roles' where 'users'.'id' = 'department_users'.'user_id' and 'users_roles'.'user_id'='users'.'id' and 'users_roles'.'role_id' not in (1,2) and 'department_users'.'department_id' = '#{department_id}'"
    User.find_by_sql(sql)
  end

  #获取某一个部门的用户列表，不包含管理员,根据访问用户权限
  def self.get_department_users_with_user_role(user_id,user_role,department_id)
    if user_role == "employee"
      sql = "select 'users'.* from 'users','department_users','users_roles' where 'users'.'id' = 'department_users'.'user_id' and 'users'.'id'='users_roles'.'user_id' and 'users_roles'.'role_id' <> 2 and 'users'.'id' = '#{user_id}'"
    elsif user_role == "admin" || user_role == "manager"
      sql = "select 'users'.* from 'users','department_users','users_roles' where 'users'.'id' = 'department_users'.'user_id' and 'users'.'id'='users_roles'.'user_id' and 'users_roles'.'role_id' <> 2 and 'department_users'.'department_id' = '#{department_id}'"
    end
    User.find_by_sql(sql)
  end

  #获取某一个用户的信息
  def self.get_one_user(user_id)
    sql = "select u.id,u.email,u.sign_in_count,u.current_sign_in_ip,u.current_sign_in_at,u.last_sign_in_ip,u.last_sign_in_at,u.is_active,du.department_id,d.department_name,ur.role_id,(select name from roles where id = ur.role_id) as role_name  
            from users as u
            left join department_users as du
            on u.id=du.user_id
            left join departments as d 
            on d.id = du.department_id
            left join users_roles as ur
            on u.id = ur.user_id 
            where u.id = '#{user_id}'"
    User.find_by_sql(sql).first
  end

  #获取部门用户列表
  def self.get_users(department_id,page)
  	if department_id.nil? || department_id == 0
      sql = "select u.id,u.email,u.sign_in_count,u.current_sign_in_ip,u.current_sign_in_at,u.last_sign_in_ip,u.last_sign_in_at,u.is_active,d.department_name,ur.role_id,(select name from roles where id = ur.role_id) as role_name  
            from users as u
            left join department_users as du
            on u.id=du.user_id
            left join departments as d 
            on d.id = du.department_id
            left join users_roles as ur
            on u.id = ur.user_id "
  		User.paginate_by_sql(sql, :page => page, :per_page => per_page)
  	else
      sql = "select u.id,u.email,u.sign_in_count,u.current_sign_in_ip,u.current_sign_in_at,u.last_sign_in_ip,u.last_sign_in_at,u.is_active,d.department_name,ur.role_id,(select name from roles where id = ur.role_id) as role_name  
            from users as u
            left join department_users as du
            on u.id=du.user_id
            left join departments as d 
            on d.id = du.department_id
            left join users_roles as ur
            on u.id = ur.user_id 
            where du.department_id = #{department_id}"
  		User.paginate_by_sql(sql, :page => page, :per_page => per_page)
  	end
  end

  #创建新用户
  def self.create_new_user(email,password)
    User.create(:email => email,:password => password)
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
