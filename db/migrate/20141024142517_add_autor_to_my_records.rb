class AddAuthorToMyRecords < ActiveRecord::Migration
  def change
    add_column :my_records, :author, :string
  end
end
