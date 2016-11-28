# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#创时间日期数据
BasicDate.destroy_all
BasicDate.create(:id => 1,:okr_date => "2016-11",:serial_number => 1)
BasicDate.create(:id => 2,:okr_date => "2016-12",:serial_number => 2)
#初始化部门数据
Department.destroy_all
Department.create(:id => 1,:department_name => "产品部")
Department.create(:id => 2,:department_name => "UED部")
Department.create(:id => 3,:department_name => "测试部")
Department.create(:id => 4,:department_name => "运维部")
Department.create(:id => 5,:department_name => "基础平台部")
Department.create(:id => 6,:department_name => "语音部")
Department.create(:id => 7,:department_name => "金融技术部")
Department.create(:id => 8,:department_name => "项目部")
#创建管理员
User.destroy_all
User.create(:id => 1,:email => "zhuangxulin@ancun.com",:password => "zhuangxulin2003")
User.create(:id => 2,:email => "admin@ancun.com",:password => "admin2016")
#创建用户权限基础数据
Role.destroy_all
Role.create(:id => 1,:name => "admin")
Role.create(:id => 2,:name => "manager")
Role.create(:id => 3,:name => "employee")
#关联用户权限
ActiveRecord::Base.connection.execute("delete from users_roles")
ActiveRecord::Base.connection.execute("insert into users_roles(user_id,role_id) values(1,1)")
ActiveRecord::Base.connection.execute("insert into users_roles(user_id,role_id) values(2,1)")
#关联部门权限
DepartmentUser.destroy_all
DepartmentUser.create(:id => 1,:department_id => 0,:user_id => 1)
DepartmentUser.create(:id => 2,:department_id => 0,:user_id => 2)
#OKR执行情况基础数据
OkrStat.create(:stats_name => '完全没有做到',:stats_number => 0,:serial_number => 1)
OkrStat.create(:stats_name => '和目标差距较大',:stats_number => 0.3,:serial_number => 2)
OkrStat.create(:stats_name => '和目标差距不大',:stats_number => 0.6,:serial_number => 3)
OkrStat.create(:stats_name => '基本上做到',:stats_number => 0.8,:serial_number => 4)
OkrStat.create(:stats_name => '完全做到',:stats_number => 1,:serial_number => 5)
OkrStat.create(:stats_name => '超出期望',:stats_number => 1.2,:serial_number => 6)
#难度系数基础数据
DifficultyDegree.create(:degree_name => '非常简单',:degree_number => 0.6,:serial_number => 1)
DifficultyDegree.create(:degree_name => '简单',:degree_number => 0.8,:serial_number => 2)
DifficultyDegree.create(:degree_name => '一般般',:degree_number => 1,:serial_number => 3)
DifficultyDegree.create(:degree_name => '有点挑战',:degree_number => 1.3,:serial_number => 4)
DifficultyDegree.create(:degree_name => '很大的挑战',:degree_number => 1.6,:serial_number => 5)
DifficultyDegree.create(:degree_name => '超出能力范围',:degree_number => 2,:serial_number => 6)

