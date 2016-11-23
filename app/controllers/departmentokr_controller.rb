class DepartmentokrController < ApplicationController
	##需要token认证的
  	before_filter :authenticate_user_from_token!
  	##需要正常的cookie认证的
	before_filter :authenticate_user!
	##获取用户权限
	before_action :get_user_role
	##获取默认的部门列表
	before_action :get_departments
	
	def index
		#基础日期列表
		@date_list = BasicDate.get_date_list
		#获取查询的日期
		okr_date = params[:okr_date]
		if okr_date.nil?
			okr_date = BasicDate.get_last_date.okr_date
		end
		@okr_date = okr_date

		#获取查询的部门
		if @current_user_department_id.nil?
			department_id = params[:department_id]
		else
			department_id = @current_user_department_id
		end
		
		@department_okrs = Departmentokr.get_department_okrs(department_id,okr_date,params[:page])
		if @department_id.nil?
			@department_name = 'ALL'
		else
			#部门名称
			@department_name = Department.get_department_name(@department_id).department_name
		end
	end

	def new
		@department_okr = Departmentokr.new
		#OKR所属日期列表
		@date_list = BasicDate.get_date_list
    	@action = :create
	end

	def create
		@department_okr = Departmentokr.create(:okr_name => department_okr_params[:okr_name],:okr_date => department_okr_params[:okr_date],:department_id => params[:department_id],:create_user_id => current_user.id)
		respond_to do |format|
        if @department_okr.save
          	format.html { redirect_to @department_okr, notice: 'Department OKR was successfully created.' }
        else
        	@date_list = BasicDate.get_date_list
          	format.html { render :new ,notice: 'Department OKR was unsuccessfully created.'}
        end
      end
	end

	def edit
		@department_okr = Departmentokr.find(params[:id])
		@date_list = BasicDate.get_date_list
    	@action = :update
  	end

	def update
  		@department_okr = Departmentokr.show(params[:id])
  		respond_to do |format|
    		if @department_okr.update_attributes(:okr_name => department_okr_params["okr_name"],
                                      :okr_date => department_okr_params["okr_date"]
                                      )
	    		
          		format.html { redirect_to department_okr_url, notice: 'Department OKR was successfully updated.' }
    		else
      			format.html { render action: "edit" ,notice: 'Department OKR was unsuccessfully updated.'}
    		end
    	end
  	end

  	def destroy
  		@department_okr = Departmentokr.find(params[:id])
  		@department_okr.destroy
  		respond_to do |format|
    		format.html { redirect_to departmentokr_index_url }
  		end
	end

	def show
    	@department_okr = Departmentokr.find(params[:id])
    	@department_name = Department.get_department_name(@department_okr.department_id).department_name
  	end


	private
  	def department_okr_params
    	params.require(:departmentokr).permit(:id,:department_id,:okr_name,:okr_date)
  	end

 end
