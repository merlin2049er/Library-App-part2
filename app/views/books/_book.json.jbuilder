json.extract! book, :id, :Title, :Author, :Genre, :Subgenre, :Pages, :Publisher, :Copies, :created_at, :updated_at
json.url book_url(book, format: :json)
