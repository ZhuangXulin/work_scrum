class Departmentokr < ActiveRecord::Base

	validates_presence_of :okr_name,  :message => "不能够为空!"
	validates_presence_of :okr_date,  :message => "不能够为空!"
	validates_presence_of :department_id,  :message => "不能够为空!"


	self.per_page = 15

	def self.get_department_okrs(department_id,okr_date,page)
		if (okr_date.nil?)
			okr_date = '2016-11'
		end
		Departmentokr.where(:okr_date => okr_date,:department_id => department_id).paginate(:page => page, :per_page => per_page)
	end
end
