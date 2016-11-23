class OkrStat < ActiveRecord::Base

	def self.get_okr_data_list
		OkrStat.order("serial_number")
	end

	def self.get_okr_number(okr_id)
		OkrStat.find(okr_id).stats_number
	end
end
