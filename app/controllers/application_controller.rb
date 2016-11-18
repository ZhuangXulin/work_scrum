class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  

  def after_sign_in_path_for(resource)
	   if resource.is_a?(User)
	     if User.count == 1
	       resource.add_role 'admin'
	     end
	     resource
	   end
	   root_path
  end

  def rescue_record_not_found       
    begin       
      yield       
    rescue ActiveRecord::RecordNotFound       
      render :file => "#{RAILS_ROOT}/public/404.html"      
    end       
  end


 #获取当前用户在部门中的角色
  def get_user_role
   	user_role_info = DepartmentUser.get_user_role_in_department(current_user.id)
	  @user_role = "employee"
  	if user_role_info.user_role == 0
  		@user_role = "admin"
  	elsif user_role_info.user_role == 1
  		@user_role = "manager"
  		@department_id = user_role_info.department_id
  	end
  end 

  def get_departments
    #部门列表
    if @department_id.nil?
      @departments = Department.get_departments(nil)
    else
      @departments = Department.get_departments(@department_id)
    end
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
