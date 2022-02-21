class AddLibraryToCheckedout < ActiveRecord::Migration[6.1]
  def change
    add_column :checkedouts, :library, :string
  end
end
