class User < ApplicationRecord
  validate :over_num

  def over_num
    errors.add(:user, "oops!") if User.count > 1
  end
end
