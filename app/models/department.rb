class Department < ActiveRecord::Base
	self.per_page = 15
	
	#根据部门ID获取部门名称
	def self.get_department_name(department_id)
		Department.find(department_id)
	end

	#获取部门列表
	def self.get_departments
		Department.all
	end


end
