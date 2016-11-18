class Role < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource, :polymorphic => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  #用户权限
  def self.add_user_role(user_id)
  	ActiveRecord::Base.connection.execute("insert into users_roles(user_id,role_id) values('#{user_id}',3)")
  end
end
