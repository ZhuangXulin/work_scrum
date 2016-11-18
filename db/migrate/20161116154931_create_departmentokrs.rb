class CreateDepartmentokrs < ActiveRecord::Migration
  def change
    create_table :departmentokrs do |t|
      t.string :okr_name          #OKR内容
      t.string :okr_date          #OKR月份
      t.float :okr_proportion     #OKR占比（比例）
      t.string :okr_stats         #OKR完成状态
      t.integer :okr_score        #OKR得分
      t.string :assessment_person      #评定人

      t.timestamps null: false
    end
  end
end
