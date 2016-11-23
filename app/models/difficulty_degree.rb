class DifficultyDegree < ActiveRecord::Base
	#获取难度系数列表
	def self.get_okr_degree_list
		DifficultyDegree.order("serial_number")
	end

	#获取难度系数对应的分数
	def self.get_okr_degree_number(degree_id)
		DifficultyDegree.find(degree_id).degree_number
	end

end
