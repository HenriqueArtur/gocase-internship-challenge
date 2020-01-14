class Batch < ApplicationRecord
  validates :reference, presence: true, uniqueness: true
  validates :purchase_channel, presence: true
  has_many :orders
end
