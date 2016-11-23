class CreateBasicDates < ActiveRecord::Migration
  def change
    create_table :basic_dates do |t|
      t.string :okr_date ,null: false         #OKR日期
      t.integer :serial_number  ,null: false  #日期序号，序号最大的显示在最后

      t.timestamps null: false
    end
  end
end
