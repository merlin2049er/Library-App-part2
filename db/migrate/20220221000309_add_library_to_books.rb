class AddLibraryToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :Library, :string
  end
end
