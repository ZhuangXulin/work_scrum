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
	if user_role_info.user_role = 0
		@user_role = "admin"
	elsif user_role_info.user_role = 1
		@user_role = "manager"
		@department_id = user_role_info.department_id
	end		
  end 

end
