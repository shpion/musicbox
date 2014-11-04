class AddFileNameToMyRecords < ActiveRecord::Migration
  def change
    add_column :my_records, :file_name, :string
  end
end
