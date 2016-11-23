class CreateDifficultyDegrees < ActiveRecord::Migration
  def change
    create_table :difficulty_degrees do |t|
      t.string :degree_name,null: false    #难度系数名称
      t.float :degree_number,null: false   #难度系数得分
      t.integer :serial_number,null: false   #显示序号

      t.timestamps null: false
    end
  end
end
