class DepartmentController < ApplicationController
	before_filter :authenticate_user!
	before_action :get_user_role

	def index
		@departments = Department.get_departments

		department_id = params[:department_id]
		#获取用户列表
		@users = User.get_users(department_id,params[:page])
		#部门信息
		if department_id.nil?
			@department_name = 'ALL'
		else
			#部门名称
			@department_name = Department.get_department_name(department_id).department_name
		end
	end

	def new
		
	end

	def create
		
	end

	def show
		
	end


	private
  	def department_params
    	params.require(:department).permit(:id,:email,:department_id)
  	end

end
