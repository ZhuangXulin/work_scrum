class AddAssessmentTimeToDepartmentokr < ActiveRecord::Migration
  def change
    add_column :departmentokrs, :assessment_time, :datetime  #评定时间
  end
end
