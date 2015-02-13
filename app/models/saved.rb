class Saved < ActiveRecord::Base
  belongs_to :user
  has_many :subscriber
end
