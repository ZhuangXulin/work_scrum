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


	#部门首页
	def index
		Log.log_user_action(current_user.id,request.remote_ip,'View Department Home')
		#验证页面是否输入了department_id参数
		@search_department_id = params[:department_id]
		if !@search_department_id.nil?
			#获取用户列表
			@users = User.get_users(params[:department_id],params[:page])
			#部门名称
			@department_name = Department.get_department_name(params[:department_id]).department_name
		else
			#获取用户列表
			@users = User.get_users(@current_user_department_id,params[:page])
			#部门名称
			@department_name = t('department.display_range')
		end
	end

	#新建用户
	def new
		Log.log_user_action(current_user.id,request.remote_ip,'Ready to Add Employee')
		@user = User.new
    	@action = :create
	end

	#保存新建的用户
	def create
		Log.log_user_action(current_user.id,request.remote_ip,'Add New Employee')
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
		Log.log_user_action(current_user.id,request.remote_ip,'Active Employee')
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
		Log.log_user_action(current_user.id,request.remote_ip,'Unactive Employee')
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
		Log.log_user_action(current_user.id,request.remote_ip,'Ready to Update Employee')
		user_id = params[:user_id]
		if user_id.nil?
			user_id = current_user.id
			@user = User.get_one_user(user_id)
			#待编辑用户ID
			@user_id = @user.id
			@update_password = true
			@action = :update
		else
			@user = User.get_one_user(user_id)
			#待编辑用户所属的部门
			@user_department_id = DepartmentUser.get_user_department_id(user_id)
			#待编辑用户权限
			@user_role = @user.role_id
			#待编辑用户ID
			@user_id = @user.id
	    	@action = :update
		end
  	end

  	#编辑雇员信息
  	def update
  		Log.log_user_action(current_user.id,request.remote_ip,'Update Employee')
		result = false
		ActiveRecord::Base.transaction do
			if params[:department_id].nil?
				user = User.find(params[:user][:id])
				user.update_attributes(:password => params[:user][:password])
			else
				user = User.find(params[:user][:id])
				user.update_attributes(:password => params[:user][:password])
				#更新人员所属部门
				department_user = DepartmentUser.where(:user_id => params[:user][:id]).first
				department_user.update_attributes(:department_id => params[:department_id])
				#更新人员权限
				ActiveRecord::Base.connection.execute("update users_roles set role_id = #{params[:user_role]} where user_id = #{params[:user][:id]}")
			end
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
