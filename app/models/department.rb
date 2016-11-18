class Department < ActiveRecord::Base
	validates_presence_of :email,  :message => "不能够为空!"
	validates_presence_of :password,  :message => "不能够为空!"

	self.per_page = 15

	#根据部门ID获取部门名称
	def self.get_department_name(department_id)
		Department.find(department_id)
	end

	#根据用户ID获取用户所在部门名称
	def self.get_department_name_by_user(user_id)
		ActiveRecord::Base.connection.execute("select department_name from departments as d,department_users as du where d.id = du.department_id and du.user_id = '#{user_id}' ")
	end

	#获取部门列表
	def self.get_departments(department_id)
		if department_id.nil?
			Department.all
		else
			Department.where(:id => department_id)
		end
	end



end
