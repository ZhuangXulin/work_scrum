class CreateDepartmentUsers < ActiveRecord::Migration
  def change
    create_table :department_users do |t|
      t.integer :department_id   ,null: false    #部门ID
      t.integer :user_id    ,null: false  #用户ID

      t.timestamps null: false
    end
  end
end
