class Order < ApplicationRecord
    validates :reference, uniqueness: true
    validates :purchase_channel, presence: true
    validates :client_name, presence: true, allow_blank: false
    validates :address, presence: true, allow_blank: false
    validates :delivery_service, presence: true
    validates :total_value, presence: true, allow_blank: false
    validates :status, presence: true
    
    belongs_to :batch, optional: true
end
