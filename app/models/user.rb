class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :saved

  # Convert username to friendly url format
  def slug
    if name.present?
      name.downcase.gsub(" ", "-").parameterize
    end
  end

  # Change default param for user from id to id-name for friendly urls.
  # When finding in DB, Rails auto calls .to_i on param, which tosses
  # name and doesn't cause any problems in locating user.
  def to_param
    if name.present?
      "#{id}-#{name}"
    end
  end
end
