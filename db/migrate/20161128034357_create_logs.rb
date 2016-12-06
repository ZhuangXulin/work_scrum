class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :user_id,null: false,default: ""
      t.string :user_ip,null: false,defalut: ""
      t.string :type_of_action,null: false,default: ""

      t.timestamps null: false
    end
  end
end
