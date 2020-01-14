class Order < ApplicationRecord
    validates :reference, presence: true, uniqueness: true
    validates :purchase_channel, presence: true
    validates :client_name, presence: true
    validates :address, presence: true
    validates :delivery_service, presence: true
    validates :total_value, presence: true
    validates :status, presence: true
    belongs_to :batch, optional: true
end
