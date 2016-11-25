class Personalokr < ActiveRecord::Base
	self.per_page = 15

	def self.get_personal_okrs(operate_user_id,operate_user_role,search_user_id,okr_date,page)
		if search_user_id.nil?
			if operate_user_role == "admin"
				sql = "SELECT 'personalokrs'.*,'users'.'email',(SELECT email FROM USERS where id = 'personalokrs'.assessment_person ) as assessment_person_email FROM 'personalokrs' left JOIN 'users' ON 'users'.'id' = 'personalokrs'.'user_id' WHERE 'personalokrs'.'okr_date' = '#{okr_date}' "
			elsif operate_user_role == "manager"
				sql = "SELECT 'personalokrs'.*,'users'.'email',(SELECT email FROM USERS where id = 'personalokrs'.assessment_person ) as assessment_person_email FROM 'personalokrs' left JOIN 'users' ON 'users'.'id' = 'personalokrs'.'user_id' 
						WHERE 'users'.'id' in (
						select 'department_users'.'user_id' from 'department_users' where 'department_users'.'department_id' in (
						select 'department_users'.'department_id' from 'department_users' where 'department_users'.'user_id' ='#{operate_user_id}'))
						and 'personalokrs'.'okr_date' = '#{okr_date}'"
			else
				sql = "SELECT 'personalokrs'.*,'users'.'email',(SELECT email FROM USERS where id = 'personalokrs'.assessment_person ) as assessment_person_email FROM 'personalokrs' left JOIN 'users' ON 'users'.'id' = 'personalokrs'.'user_id' WHERE 'personalokrs'.'okr_date' = '#{okr_date}' AND 'personalokrs'.'user_id' = #{operate_user_id} "
			end
		else
			sql = "SELECT 'personalokrs'.*,'users'.'email',(SELECT email FROM USERS where id = 'personalokrs'.assessment_person ) as assessment_person_email FROM 'personalokrs' left JOIN 'users' ON 'users'.'id' = 'personalokrs'.'user_id' WHERE 'personalokrs'.'okr_date' = '#{okr_date}' AND 'personalokrs'.'user_id' = #{search_user_id} "
		end
		Personalokr.paginate_by_sql(sql ,:page => page, :per_page => per_page)
	end

	#获取个人OKR的详细信息
	def self.get_personal_okr_info(okr_id)
		sql = "select personalokrs.*,(select email from users where id = personalokrs.user_id ) as user_email,
			(select email from users where id = personalokrs.assessment_person) as assessment_person_email,
			(select stats_name from okr_stats where id = personalokrs.okr_stats) as okr_stats_name,
			(select degree_name from difficulty_degrees where id = personalokrs.okr_degree_of_difficulty) as okr_degree_of_difficulty_name from personalokrs where personalokrs.id = #{okr_id}"
		Personalokr.find_by_sql(sql).first
	end
end
