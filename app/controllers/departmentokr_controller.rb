class DepartmentokrController < ApplicationController
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
	
	def index
		Log.log_user_action(current_user.id,request.remote_ip,'View Department OKR')
		#基础日期列表
		@date_list = BasicDate.get_date_list
		#获取查询的日期
		okr_date = params[:okr_date]
		if okr_date.nil?
			okr_date = BasicDate.get_last_date.okr_date
		end
		@search_okr_date = okr_date

		#获取查询的部门
		if !params[:department_id].nil?
			department_id = params[:department_id]
		else
			department_id = @current_user_department_id
		end
		@search_department_id = department_id
		@department_okrs = Departmentokr.get_department_okrs(department_id,okr_date,params[:page])
		if @search_department_id == 0 || @search_department_id.nil?
			@search_department_name = t('departmentokr.display_range')
		else
			#部门名称
			@search_department_name = Department.get_department_name(@search_department_id).department_name
		end
		#计算部门总分
		@total_score = 0
		@total_proportion = 0
		if !@department_okrs.nil?
			@department_okrs.each {|department_okr| 
			if !department_okr.okr_score.nil?
				@total_score += department_okr.okr_score
			end
			if !department_okr.okr_proportion .nil?
				@total_proportion += department_okr.okr_proportion 
			end
			}
		end
		@total_score = @total_score.round(3)
	end

	def new
		Log.log_user_action(current_user.id,request.remote_ip,'Ready to Add Department OKR')
		@department_okr = Departmentokr.new
		#OKR所属日期列表
		@date_list = BasicDate.get_date_list
    	@action = :create
	end

	def create
		Log.log_user_action(current_user.id,request.remote_ip,'Add Department OKR')
		result = false
		if can_create_or_update?(department_okr_params[:okr_date])
			@department_okr = Departmentokr.create(:okr_name => department_okr_params[:okr_name],:okr_date => department_okr_params[:okr_date],:department_id => params[:department_id],:create_user_id => current_user.id)
			@department_okr.save
			result = true
		end
		respond_to do |format|
        if result
          	format.html { redirect_to @department_okr, notice: t('departmentokr.notice_message.create_successful') }
        else
        	@department_okr = Departmentokr.new
        	@date_list = BasicDate.get_date_list
        	@action = :create
        	flash[:alert] = t('departmentokr.alert_message.create_unsuccessful')
          	format.html { render :new }
        end
      end
	end

	def edit
		Log.log_user_action(current_user.id,request.remote_ip,'Ready to Update Department OKR')
		@department_okr = Departmentokr.find(params[:id])
		#日期列表
		@date_list = BasicDate.get_date_list
		#完成状态列表
		@okr_stats = OkrStat.get_okr_data_list
		#难度系数列表
		@degrees = DifficultyDegree.get_okr_degree_list
    	@action = :update
  	end

	def update
		Log.log_user_action(current_user.id,request.remote_ip,'Update Department OKR')
  		@department_okr = Departmentokr.find(params[:id])

  		respond_to do |format|
  			#系统管理员能够对OKR进行评定，部门管理员只能够修改自己的OKR内容
  			if @current_user_role == "admin"
  				degree_number = DifficultyDegree.get_okr_degree_number(department_okr_params[:okr_degree_of_difficulty])
  				okr_number = OkrStat.get_okr_number(department_okr_params[:okr_stats])
  				#计算得分
  				score = (okr_number * degree_number * department_okr_params[:okr_proportion].to_f).round(3)
  				result = @department_okr.update_attributes(:okr_name => department_okr_params["okr_name"],
                                      :okr_date => department_okr_params["okr_date"],:okr_proportion => department_okr_params[:okr_proportion],:okr_stats => department_okr_params[:okr_stats],
                                      :okr_score => score,:description => department_okr_params[:description],:assessment_time => Time.new.strftime("%Y-%m-%d %H:%M:%S"),
                                      :assessment_person => current_user.id,:okr_degree_of_difficulty => department_okr_params[:okr_degree_of_difficulty]
                                      )
  			elsif @current_user_role == "manager"
  				if can_create_or_update?(department_okr_params["okr_date"]) && @department_okr.okr_score.nil?
  					result = @department_okr.update_attributes(:okr_name => department_okr_params["okr_name"],
                                      :okr_date => department_okr_params["okr_date"]
                                      )
  				else
  					result = false
  				end
  				
  			end

    		if result
          		format.html { redirect_to departmentokr_url, notice: t('departmentokr.notice_message.update_successful') }
    		else
      			format.html { redirect_to departmentokr_url ,alert: t('departmentokr.alert_message.update_unsuccessful') }
    		end
    	end
  	end

  	def destroy
  		Log.log_user_action(current_user.id,request.remote_ip,'Destrop Department OKR')
  		@department_okr = Departmentokr.find(params[:id])
  		result = false
  		if can_create_or_update?(@department_okr.okr_date) || @current_user_role == "admin"
  			@department_okr.destroy
  			result = true
  		end
  		respond_to do |format|
  			if result
  				format.html { redirect_to departmentokr_index_url , notice: t('departmentokr.notice_message.destroy_successful') }
  			else
    			format.html { redirect_to departmentokr_index_url , alert: t('departmentokr.alert_message.destroy_successful') }
    		end
  		end
	end

	def show
		Log.log_user_action(current_user.id,request.remote_ip,'Show Department OKR Info')
    	@department_okr = Departmentokr.get_department_okr_info(params[:id])
  	end


	private
  	def department_okr_params
    	params.require(:departmentokr).permit(:id,:department_id,:okr_name,:okr_date,:okr_proportion,:okr_score,:okr_stats,:okr_degree_of_difficulty,:description)
  	end

  	#判断是否能够修改数据，每个月5号以后，本人无法修改上个月之前的数据（manager和admin可以修改）
  	def can_create_or_update?(data_belong_date)
  		current_year = Time.new.strftime("%Y").to_i
  		current_month = Time.new.strftime("%m").to_i
  		current_day = Time.new.strftime("%d").to_i
  		data_belong_year = data_belong_date[0,4].to_i
  		data_belong_month = data_belong_date[5,6].to_i
  		if current_year == data_belong_year
  			if current_month == data_belong_month
  				if current_day > 30
  					return false
  				else
  					return true
  				end
  			elsif current_month > data_belong_month
  				return false
  			else
  				return true
  			end
  		elsif current_year < data_belong_year
  			return true
  		elsif current_year == data_belong_year + 1
  			if data_belong_month != 12 && current_month != 1
  				return false
  			elsif current_day > 30
  				return false
  			else
  				return true
  			end
  		else
  			return false
  		end
  	end

 end
