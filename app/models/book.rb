class Book < ApplicationRecord
  #belongs_to :user
  validates :Library, presence: true
  validates :Title, presence: true

  validates :Genre, presence: true
  validates :Pages, presence: true

  validates :Copies, presence: true
  has_many :checkedouts

end
