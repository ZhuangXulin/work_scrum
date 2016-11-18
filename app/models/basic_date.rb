class BasicDate < ActiveRecord::Base

	def self.get_date_list
		BasicDate.order("serial_number desc")
	end

	def self.get_last_date
		BasicDate.last()
	end
end
