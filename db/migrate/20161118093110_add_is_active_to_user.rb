class AddIsActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean, null: false, default: true   #用户状态，true:正常,false:锁定
  end
end
