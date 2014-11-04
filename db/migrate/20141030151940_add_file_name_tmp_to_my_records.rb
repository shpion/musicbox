class AddFileNameTmpToMyRecords < ActiveRecord::Migration
  def change
    add_column :my_records, :file_name_tmp, :string
  end
end
