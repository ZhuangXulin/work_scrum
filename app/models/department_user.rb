class DepartmentUser < ActiveRecord::Base
	#获取用户的部门ID
	def self.get_user_department_id(user_id)
		DepartmentUser.find_by_sql("SELECT department_id FROM department_users WHERE user_id = #{user_id}" ).first.department_id
	end

	#新增部门中用户的权限
	def self.add_user_to_department(user_id,department_id)
		DepartmentUser.create(:user_id => user_id, :department_id => department_id)
	end
end
