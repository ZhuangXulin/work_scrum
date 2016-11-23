class PersonalokrController < ApplicationController
	##需要token认证的
  	before_filter :authenticate_user_from_token!
  	##需要正常的cookie认证的
	before_filter :authenticate_user!
	##获取用户权限
	before_action :get_user_role
	#获取默认权限列表
	before_action :get_roles

	def index
		#基础日期列表
		@date_list = BasicDate.get_date_list
		#获取查询的日期
		okr_date = params[:okr_date]
		if okr_date.nil?
			okr_date = BasicDate.get_last_date.okr_date
		end
		@search_okr_date = okr_date

		#获取用户列表
		if @current_user_role == "admin"
			@users = User.get_all_users
		elsif @current_user_role == "manager"
			@users = User.get_department_users(@current_user_department_id)
		else
			@users = User.where(:id => current_user.id)
		end
		#personal okr列表
		@search_user_id = params[:user_id]

		@personal_okrs = Personalokr.get_personal_okrs(current_user.id,@current_user_role,@search_user_id,okr_date,params[:page])
		#计算个人总分
		@total_score = 0
		@total_proportion = 0
		if !@personal_okrs.nil?
			@personal_okrs.each {|personal_okr| 
			if !personal_okr.okr_score.nil?
				@total_score += personal_okr.okr_score
			end
			if !personal_okr.okr_proportion .nil?
				@total_proportion += personal_okr.okr_proportion 
			end
			}
		end
		@total_score = @total_score.round(3)
	end

	def new
		@personal_okr = Personalokr.new
		#OKR所属日期列表
		@date_list = BasicDate.get_date_list
		#部门用户列表
		@department_users = User.get_department_users_with_user_role(current_user.id,@current_user_role,@current_user_department_id)
		#完成状态列表
		@okr_stats = OkrStat.get_okr_data_list
		#难度系数列表
		@degrees = DifficultyDegree.get_okr_degree_list
    	@action = :create
	end

	def create
		@personal_okr = Personalokr.create(:okr_name => personal_okr_params[:okr_name],:okr_date => personal_okr_params[:okr_date],:user_id => current_user.id)
		respond_to do |format|
        if @personal_okr.save
          	format.html { redirect_to @personal_okr, notice: 'Personal OKR was successfully created.' }
        else
        	@date_list = BasicDate.get_date_list
          	format.html { render :new ,notice: 'Personal OKR was unsuccessfully created.'}
        end
      end
	end

	def show
    	@personal_okr = Personalokr.get_personal_okr_info(params[:id])
	end

	#删除个人的okr（okr所有者，部门管理者，系统管理员操作）
	def destroy
  		personal_okr = Personalokr.find(params[:id])
  		respond_to do |format|
	  		if personal_okr.assessment_time.nil?
	  			result = personal_okr.destroy
	  			format.html { redirect_to personalokr_index_url, notice: 'Personal OKR was successfully destroy.' }
	  		else
    			format.html { redirect_to personalokr_index_url ,notice: 'Personal OKR can not destroy after assessment.'}
    		end
  		end
	end

	def edit
		@personal_okr = Personalokr.find(params[:id])
		#日期列表
		@date_list = BasicDate.get_date_list
		#部门用户列表
		@department_users = User.get_department_users_with_user_role(current_user.id,@current_user_role,@current_user_department_id)
		#完成状态列表
		@okr_stats = OkrStat.get_okr_data_list
		#难度系数列表
		@degrees = DifficultyDegree.get_okr_degree_list
    	@action = :update
  	end

  	def update
  		@personal_okr = Personalokr.find(params[:id])
  		respond_to do |format|
  			#部门管理员或者是系统管理员能够对OKR进行评定，雇员只能够修改自己的OKR内容
  			if @current_user_role == "admin" || @current_user_role == "manager"
  				degree_number = DifficultyDegree.get_okr_degree_number(personal_okr_params[:okr_degree_of_difficulty])
  				okr_number = OkrStat.get_okr_number(personal_okr_params[:okr_stats])
  				#计算得分
  				score = (okr_number * degree_number * personal_okr_params[:okr_proportion].to_f).round(3)
  				result = @personal_okr.update_attributes(:okr_name => personal_okr_params["okr_name"],
                                      :okr_date => personal_okr_params["okr_date"],:okr_proportion => personal_okr_params[:okr_proportion],:okr_stats => personal_okr_params[:okr_stats],
                                      :okr_score => score,:description => personal_okr_params[:description],:assessment_time => Time.new.strftime("%Y-%m-%d %H:%M:%S"),
                                      :assessment_person => current_user.id,:okr_degree_of_difficulty => personal_okr_params[:okr_degree_of_difficulty]
                                      )
  			else
  				if @personal_okr.okr_score.nil?
  					result = @personal_okr.update_attributes(:okr_name => personal_okr_params["okr_name"],
                                      :okr_date => personal_okr_params["okr_date"]
                                      )
  				else
  					result = false
  				end
  				
  			end

    		if result
          		format.html { redirect_to personalokr_url, notice: 'Personal OKR was successfully updated.' }
    		else
      			format.html { redirect_to personalokr_url ,notice: 'Personal OKR can not update after assessment.'}
    		end
    	end
  	end

	private
  	def personal_okr_params
    	params.require(:personalokr).permit(:id,:email,:okr_name,:okr_date,:okr_proportion,:okr_score,:okr_stats,:okr_degree_of_difficulty,:description)
  	end
end
