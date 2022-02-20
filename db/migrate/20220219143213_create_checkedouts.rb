class CreateCheckedouts < ActiveRecord::Migration[6.1]
  def change
    create_table :checkedouts do |t|
      t.integer :user_id
      t.integer :book_id
      t.datetime :checkedout
      t.datetime :duedate
      t.datetime :returndate
      t.boolean :checkedoutstatus
      t.timestamps
    end
  end
end
