class CreatePersonalokrs < ActiveRecord::Migration
  def change
    create_table :personalokrs do |t|
      t.string :okr_name          ,null: false    #OKR内容
      t.string :okr_date          ,null: false     #OKR月份
      t.float :okr_proportion     #OKR占比（比例）
      t.integer :okr_stats         #OKR完成状态，关联完成状态表
      t.integer :okr_degree_of_difficulty    #OKR难度系数，关联难度系数表
      t.float :okr_score        #OKR得分
      t.string :assessment_person      #评定人
      t.integer :user_id   ,null: false  #个人okr创建者
      t.datetime :assessment_time    #评定时间
      t.string :description    #备注/描述

      t.timestamps null: false
    end
  end
end
