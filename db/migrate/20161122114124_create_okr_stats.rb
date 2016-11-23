class CreateOkrStats < ActiveRecord::Migration
  def change
    create_table :okr_stats do |t|
      t.string :stats_name,null: false    #OKR完成情况名称
      t.float :stats_number,null: false    #完成情况对应的分数
      t.integer :serial_number,null: false   #序号

      t.timestamps null: false
    end
  end
end
