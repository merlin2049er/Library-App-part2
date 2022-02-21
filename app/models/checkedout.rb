class Checkedout < ApplicationRecord
  belongs_to :user
  belongs_to :book
  #belongs_to :library

  def user_email
    user.try(:email)
  end
end
