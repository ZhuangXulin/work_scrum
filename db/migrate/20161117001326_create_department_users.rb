class CreateDepartmentUsers < ActiveRecord::Migration
  def change
    create_table :department_users do |t|
      t.integer :department_id     #部门ID
      t.integer :user_id      #用户ID
      t.integer :user_role    #用户权限，1：部门管理者，2：部门雇员

      t.timestamps null: false
    end
  end
end
