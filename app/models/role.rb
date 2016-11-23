class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  #用户权限
  def self.add_user_role(user_id,user_role)
  	ActiveRecord::Base.connection.execute("insert into users_roles(user_id,role_id) values('#{user_id}',#{user_role})")
  end

  #获取权限列表，不包括admin
  def self.get_roles
  	sql = "select * from roles where name <> 'admin' "
  	Role.find_by_sql(sql)
  end

  #获取用户权限
  def self.get_user_role(user_id)
  	Role.find_by_sql("select 'users_roles'.* from 'users_roles' where user_id = #{user_id}").first
  end
end
