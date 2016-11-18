class AddColoumToDepartmentokr < ActiveRecord::Migration
  def change
    add_column :departmentokrs, :create_user_id, :integer   #部门okr创建者
    add_column :departmentokrs, :department_id, :integer     #部门ID
  end
end
