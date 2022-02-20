# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
csv_text = File.read(Rails.root.join('db','seeds','testdatapart1.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
puts  csv.inspect
# add books to book table
csv.each do |row|
  t = Book.new
  t.Title = row['Title']
  t.Author = row['Author']
  t.Genre = row['Genre']
  t.Subgenre = row['Subgenre']
  t.Pages = row['Pages']
  t.Publisher = row['Publisher']
  t.Copies = row['Copies']
  t.save
puts t.errors.inspect
end
