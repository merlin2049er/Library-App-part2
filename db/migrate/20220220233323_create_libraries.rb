class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries do |t|
      t.string :library
      t.string :address
      t.string :city
      t.string :postalcode
      t.string :phone
      t.string :number

      t.timestamps
    end
  end
end
