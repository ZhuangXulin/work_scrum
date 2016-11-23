class Departmentokr < ActiveRecord::Base
	belongs_to :Department

	validates_presence_of :okr_name,  :message => "OKR内容不能够为空!"
	validates_presence_of :okr_date,  :message => "OKR日期不能够为空!"
	validates_presence_of :department_id,  :message => "OKR所属部门不能够为空!"


	self.per_page = 15

	def self.get_department_okrs(department_id,okr_date,page)
		if department_id.nil? || department_id == 0
			#Departmentokr.joins(:Department).where(:okr_date => okr_date).paginate(:page => page, :per_page => per_page)
			Departmentokr.paginate_by_sql("SELECT 'departmentokrs'.*,'departments'.'department_name' FROM 'departmentokrs' left JOIN 'departments' ON 'departments'.'id' = 'departmentokrs'.'department_id' WHERE 'departmentokrs'.'okr_date' = '#{okr_date}' " ,:page => page, :per_page => per_page)
		else
			Departmentokr.paginate_by_sql("SELECT 'departmentokrs'.*,'departments'.'department_name' FROM 'departmentokrs' left JOIN 'departments' ON 'departments'.'id' = 'departmentokrs'.'department_id' WHERE 'departmentokrs'.'okr_date' = '#{okr_date}' AND 'departmentokrs'.'department_id' = #{department_id} " ,:page => page, :per_page => per_page)
		end
	end

end
