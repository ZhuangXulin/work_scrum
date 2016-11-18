class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  self.per_page = 15

  def self.get_users(department_id,page)
  	if department_id.nil?
  		User.paginate_by_sql("select u.id,u.email,u.sign_in_count,u.last_sign_in_ip,u.last_sign_in_at from users as u,department_users as d where u.id=d.user_id ", :page => page, :per_page => per_page)
  	else
  		User.paginate_by_sql("select u.id,u.email,u.sign_in_count,u.last_sign_in_ip,u.last_sign_in_at from users as u,department_users as d where u.id=d.user_id and d.department_id = #{department_id}", :page => page, :per_page => per_page)
  	end
  	
  end
end
