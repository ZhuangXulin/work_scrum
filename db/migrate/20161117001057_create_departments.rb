class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :department_name    #部门名称

      t.timestamps null: false
    end
  end
end
