class DepartmentController < ApplicationController
	##需要token认证的
  	before_filter :authenticate_user_from_token!
  	##需要正常的cookie认证的
	before_filter :authenticate_user!
	##获取用户权限
	before_action :get_user_role
	##获取默认的部门列表
	before_action :get_departments
	#获取默认权限列表
	before_action :get_roles
	around_filter :rescue_record_not_found

	#部门首页
	def index
		#验证页面是否输入了department_id参数
		if !params[:department_id].nil?
			#获取用户列表
			@users = User.get_users(params[:department_id],params[:page])
			#部门名称
			@department_name = Department.get_department_name(params[:department_id]).department_name
		else
			#获取用户列表
			@users = User.get_users(@current_user_department_id,params[:page])
			#部门名称
			@department_name = 'ALL'
		end
	end

	#新建用户
	def new
		@user = User.new
    	@action = :create
	end

	#保存新建的用户
	def create
		result = false
        #新增雇员
        ActiveRecord::Base.transaction do
  			@user = User.create_new_user(params[:user][:email],params[:user][:password])
  			@user.save
  			#关联用户权限表
	        Role.add_user_role(@user.id,params[:user_role])
	        #关联部门
			DepartmentUser.add_user_to_department(@user.id,params[:department_id])	
			result = true
		end
		respond_to do |format|
        if result
          	format.html { redirect_to '/department', notice: 'Department User was successfully created.' }
        else
          	format.html { render :new ,notice: 'Department User was unsuccessfully created.'}
        end
      end
	end

	#激活用户
	def active
		result = false
		#验证操作者是否是管理员
		if @current_user_role == 'admin' || @current_user_role == 'manager'
			User.set_active_status(params[:user_id],params[:active_status])
			result = true
		end

		respond_to do |format|
	        if result
	          	format.html { redirect_to '/department', notice: 'Update User Active Status was successfully update.' }
	        else
	          	format.html { redirect_to "/department" ,notice: 'Update User Activce Status was unsuccessfully update.'}
	        end
    	end
	end

	#锁定用户
	def unactive
		result = false
		#验证操作者是否是管理员
		if @current_user_role == 'admin' || @current_user_role == 'manager'
			User.set_active_status(params[:user_id],params[:active_status])
			result = true
		end

		respond_to do |format|
	        if result
	          	format.html { redirect_to '/department', notice: 'Update User Active Status was successfully update.' }
	        else
	          	format.html { redirect_to "/department" ,notice: 'Update User Activce Status was unsuccessfully update.'}
	        end
    	end
	end

	#准备编辑雇员信息
	def edit
		@user = User.get_one_user(params[:user_id])
		#待编辑用户所属的部门
		@user_department_id = DepartmentUser.get_user_department_id(params[:user_id])
		#待编辑用户权限
		@user_role = @user.role_id
		#待编辑用户ID
		@user_id = @user.id
    	@action = :update
  	end

  	#编辑雇员信息
  	def update
		result = false
		ActiveRecord::Base.transaction do
			user = User.find(params[:user][:id])
			user.update_attributes(:password => params[:user][:password])
			#更新人员所属部门
			department_user = DepartmentUser.where(:user_id => params[:user][:id]).first
			department_user.update_attributes(:department_id => params[:department_id])
			#更新人员权限
			ActiveRecord::Base.connection.execute("update users_roles set role_id = #{params[:user_role]} where user_id = #{params[:user][:id]}")
			result = true
		end
  		respond_to do |format|
  			if result
	          	format.html { redirect_to '/department', notice: 'Department User was successfully updated.' }
	    	else
    			@action = :update
      			format.html { render action: "edit" ,notice: 'Department User was unsuccessfully updated.'}
    		end
    	end

	end

end
