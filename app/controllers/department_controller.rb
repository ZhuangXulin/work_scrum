class DepartmentController < ApplicationController
	##需要token认证的
  	before_filter :authenticate_user_from_token!
  	##需要正常的cookie认证的
	before_filter :authenticate_user!
	##获取用户权限
	before_action :get_user_role
	##获取默认的部门列表
	before_action :get_departments

	def index
		#验证页面是否输入了department_id参数
		if !params[:department_id].nil?
			#获取用户列表
			@users = User.get_users(params[:department_id],params[:page])
			#部门名称
			@department_name = Department.get_department_name(params[:department_id]).department_name
		else
			#获取用户列表
			@users = User.get_users(@department_id,params[:page])
			#部门名称
			@department_name = 'ALL'
		end
	end

	def new
		@department_user = User.new
    	@action = :create
    	#页面按钮显示状态
    	@view_email_status = true
    	@view_department_status = true
	end

	def create
        #新增雇员
        @department_user = User.create_new_user(params[:user][:email],params[:user][:password])
        
		respond_to do |format|
        if @department_user.save
	 		#关联用户权限表
	        Role.add_user_role(@department_user.id)
	        #关联部门中雇员权限表
			DepartmentUser.add_user_role(@department_user.id,params[:department_id])	
          	format.html { redirect_to '/department', notice: 'Department User was successfully created.' }
        else
          	format.html { render :new ,notice: 'Department User was unsuccessfully created.'}
        end
      end
	end

	def edit_password
		@department_user = User.find(params[:id])
		department_name = Department.get_department_name_by_user(params[:user_id])
		if department_name.nil?
			@department_name = department_name.first.department_name
		else
			@department_name = ''
		end

		@action = :change_password
		#页面按钮显示状态
		@view_email_status = false
    	@view_department_status = false
    	@submit_value = "Update Password"
	end

	#修改密码
	def change_password
		result = false
		if params[:user][:password].nil?
			@department_user = User.update_password(current_user.id,params[:user][:password])
			result = true
		end
		respond_to do |format|
	        if result
	          	format.html { redirect_to '/department', notice: 'Update User Password was successfully created.' }
	        else
	        	@department_user = User.new
	        	@action = :update_password
	          	format.html { redirect_to "/department/edit_password/#{current_user.id}" ,notice: 'Update User Password was unsuccessfully created.'}
	        end
    	end
	end

	#激活用户
	def active
		result = false
		#验证操作者是否是管理员
		if @user_role == 'admin' || @user_role == 'manager'
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
		if @user_role == 'admin' || @user_role == 'manager'
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
		@department_user = User.find(params[:id])
    	@action = :update
    	#页面按钮显示状态
    	@view_email_status = false
    	@view_department_status = true
  	end

  	#编辑雇员信息
  	def update
  		puts @action



		department_user = User.find(params[:user][:email])
  		respond_to do |format|
    		if @department_user.update_attributes(:password => params[:user][:password])
          		format.html { redirect_to '/department', notice: 'Department User was successfully updated.' }
    		else
      			format.html { render action: "edit" ,notice: 'Department User was unsuccessfully updated.'}
    		end
    	end

	end

	private
  	def department_user_params
    	params.require(:department_user).permit(:id,:department_id)
  	end

end
