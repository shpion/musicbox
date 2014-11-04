class CreateMyRecords < ActiveRecord::Migration
  def change
    create_table :my_records do |t|
      t.integer :user_id
      t.string :name
      t.string :unic_name
      t.integer :size

      t.timestamps
    end
  end
end
