class DepartmentUser < ActiveRecord::Base
	#获取用户的权限
	def self.get_user_role_in_department(user_id)
		DepartmentUser.find_by(:user_id => user_id)
	end

	#新增部门中用户的权限
	def self.add_user_role(user_id,department_id)
		DepartmentUser.create(:user_id => user_id, :department_id => department_id)
	end
end
