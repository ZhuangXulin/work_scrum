class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  around_filter :rescue_record_not_found
  #around_filter :rescue_exception

  def after_sign_in_path_for(resource)
	   if resource.is_a?(User)
	     if User.count == 1
	       resource.add_role 'admin'
	     end
	     resource
	   end
	   root_path
  end

  #捕获找不到页面异常
  def rescue_record_not_found
    begin       
      yield       
    rescue ActiveRecord::RecordNotFound       
      render :file => "/public/500.html" 
    end    
  end

  #NoMethodError
  def rescue_exception
    begin       
      yield       
    rescue Exception     
      render :file => "/public/500.html" 
    end    
  end


  #获取当前用户在部门中的角色及所在的部门ID
  def get_user_role
   	user_role_info = User.find_by_sql("select 'users_roles'.role_id from 'users_roles' where 'users_roles'.'user_id' = #{current_user.id}").first.role_id
    user_department_id = DepartmentUser.get_user_department_id(current_user.id)
    #登陆用户所在的部门ID
    @current_user_department_id = user_department_id
    #登陆用户的权限
	  @current_user_role = "employee"
    if user_role_info.nil?
      
  	elsif user_role_info == 1
  		@current_user_role = "admin"
  	elsif user_role_info == 2
  		@current_user_role = "manager"
  	end
  end 

  #部门列表（如果是管理员，获取全部列表，如果是部门管理者，获取部门名称
  def get_departments
    #部门列表
    if @current_user_department_id.nil? || @current_user_department_id == 0
      @departments = Department.get_departments(nil)
    else
      @departments = Department.get_departments(@current_user_department_id)
    end
  end

  #获取权限列表（如果是管理员，或者是部门管理者，获取全部列表）
  def get_roles
    @roles = Role.get_roles
  end

  private
 
  # 判断token的值是否存在，若存在且能在User表中找到相应的，就登录此用户
  def authenticate_user_from_token!
    token = params[:token].presence
    user = token && User.find_by_authentication_token(token.to_s)
    if user
      sign_in user, store: false
    end
  end

end
