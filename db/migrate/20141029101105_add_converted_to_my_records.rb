class AddConvertedToMyRecords < ActiveRecord::Migration
  def change
    add_column :my_records, :converted, :tinyint
  end
end
