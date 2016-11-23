class Departmentokr < ActiveRecord::Base
	belongs_to :Department

	validates_presence_of :okr_name,  :message => "OKR内容不能够为空!"
	validates_presence_of :okr_date,  :message => "OKR日期不能够为空!"
	validates_presence_of :department_id,  :message => "OKR所属部门不能够为空!"


	self.per_page = 15

	#获取OKR列表
	def self.get_department_okrs(department_id,okr_date,page)
		if department_id.nil? || department_id == 0
			#Departmentokr.joins(:Department).where(:okr_date => okr_date).paginate(:page => page, :per_page => per_page)
			Departmentokr.paginate_by_sql("SELECT 'departmentokrs'.*,'departments'.'department_name',(SELECT email FROM USERS where id = 'departmentokrs'.assessment_person ) as assessment_person_email FROM 'departmentokrs' left JOIN 'departments' ON 'departments'.'id' = 'departmentokrs'.'department_id' WHERE 'departmentokrs'.'okr_date' = '#{okr_date}' " ,:page => page, :per_page => per_page)
		else
			Departmentokr.paginate_by_sql("SELECT 'departmentokrs'.*,'departments'.'department_name',(SELECT email FROM USERS where id = 'departmentokrs'.assessment_person ) as assessment_person_email FROM 'departmentokrs' left JOIN 'departments' ON 'departments'.'id' = 'departmentokrs'.'department_id' WHERE 'departmentokrs'.'okr_date' = '#{okr_date}' AND 'departmentokrs'.'department_id' = #{department_id} " ,:page => page, :per_page => per_page)
		end
	end

	def self.get_department_okr_info(okr_id)
		sql = "select departmentokrs.*,(select email from users where id = departmentokrs.create_user_id ) as create_user_email,
			(select email from users where id = departmentokrs.assessment_person) as assessment_person_email,
			(select stats_name from okr_stats where id = departmentokrs.okr_stats) as okr_stats_name,
			(select department_name from departments where id = departmentokrs.department_id) as department_name,
			(select degree_name from difficulty_degrees where id = departmentokrs.okr_degree_of_difficulty) as okr_degree_of_difficulty_name from departmentokrs where departmentokrs.id = #{okr_id}"
		Departmentokr.find_by_sql(sql).first
	end

end
