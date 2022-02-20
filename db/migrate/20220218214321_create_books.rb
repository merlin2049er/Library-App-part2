class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :Title
      t.string :Author
      t.string :Genre
      t.string :Subgenre
      t.integer :Pages
      t.string :Publisher
      t.integer :Copies

      t.timestamps
    end
  end
end
