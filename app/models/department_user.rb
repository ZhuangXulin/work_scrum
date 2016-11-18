class DepartmentUser < ActiveRecord::Base

	def self.get_user_role_in_department(user_id)
		DepartmentUser.find_by(:user_id => user_id)
	end
end
