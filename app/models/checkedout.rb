class Checkedout < ApplicationRecord
  belongs_to :user
  belongs_to :book

  def user_email
    user.try(:email)
  end
end
